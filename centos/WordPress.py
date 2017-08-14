import re
import os
from subprocess import call
import fileinput


def get_customer_path(customer_ID):
    return "/storage/content/{}/{}".format(customer_ID[5:], customer_ID)


def get_connection_string(wp_config_path):
    wp_config = open(wp_config_path, "r").read()
    fillers = {"n":"[\t ]*\n[\t ]*", "i":"[^ \t\n]+?", "w":"[ \t]*"}
    con_pattern = {}
    con_pattern["name"] = "{n}define\('DB_NAME', '({i})'\);"
    con_pattern["user"] = "{n}define\('DB_USER', '({i})'\);"
    con_pattern["pass"] = "{n}define\('DB_PASSWORD', '({i})'\);"
    con_pattern["host"] = "{n}define\('DB_HOST', '({i})'\);"
    con = {}
    for key, pattern in con_pattern.iteritems():
        con[key] = re.findall(pattern.format(**fillers), wp_config)[-1]
    return con


def change_connection_string(wp_config_path, new_con):
    wp_config = open(wp_config_path, "r").read()
    backup(wp_config_path)
    fillers = {"n":"[\t ]*\n[\t ]*", "i":"[^ \t\n]+?", "w":"[ \t]*"}
    con_pattern = {}
    con_pattern["name"] = "{n}define\('DB_NAME', '({i})'\);"
    con_pattern["user"] = "{n}define\('DB_USER', '({i})'\);"
    con_pattern["pass"] = "{n}define\('DB_PASSWORD', '({i})'\);"
    con_pattern["host"] = "{n}define\('DB_HOST', '({i})'\);"
    for key, pattern in con_pattern.iteritems():
        r = re.compile(pattern.format(**fillers))
        wp_config = wp_config.replace(r.search(wp_config).group(1), new_con[key])
    open(wp_config_path, "w").write(wp_config)


def get_migration_string(customer_ID):
    path = get_customer_path(customer_ID)
    migration_credentials = open("{}/migration_credentials.txt".format(path)).read()
    fillers = {"n":"[\t ]*\n[\t ]*", "i":"[^ \t\n]+?", "w":"[ \t]*"}
    old_name_pattern = "New database credentials for (?P<old_db>{i}):{n}{n}"
    host_pattern = "Host:{w}(?P<host>{i}){n}"
    name_pattern = "Database:{w}(?P<name>{i}){n}"
    user_pattern = "Username:{w}(?P<user>{i}){n}"
    password_pattern = "Password:{w}(?P<pass>{i}){n}"
    migration_pattern = old_name_pattern + host_pattern + name_pattern + user_pattern + password_pattern
    regex = re.compile(migration_pattern.format(**fillers))
    return [m.groupdict() for m in regex.finditer(migration_credentials)]


def get_wp_configs(customer_ID):
    path = get_customer_path(customer_ID)
    dirs = os.listdir(path)
    wp_configs = []
    for folder in dirs:
        try:
            config = "{}/{}/public_html/wp-config.php".format(path, folder)
            open(config)
            wp_configs.append(config)
        except:
            pass
    return wp_configs


def fix_migrated_sites(customer_ID):
    path = get_customer_path(customer_ID)
    wp_configs = get_wp_configs(customer_ID)
    migration_cons = get_migration_string(customer_ID)
    for config in wp_configs:
        old_con = get_connection_string(config)
        for con in migration_cons:
            if con["old_db"] == old_con["name"]:
                raw_input("The connection string of {} will now be updated".format(config))
                change_connection_string(config, con)
                # print "The connection string of {} has been updated".format(path.basename(config))


def download_sql(connection_string):
    call("mysqldump --user={user} --password={pass} --host={host} {name} > {name}.sql".format(**connection_string), shell=True)
    return "{name}.sql".format(**connection_string)


def upload_sql(connection_string):
    raw_input("uploading!")
    print "mysql --user={user} --password='{pass}' --host={host} {name} < {name}.sql".format(**connection_string)
    call("mysql --user={user} --password='{pass}' --host={host} {name} < {name}.sql".format(**connection_string), shell=True)


def restore_backup(path):
    con = get_connection_string("{}/wp-config.php".format(path))
    raw_input("restoring db_backup/{name}.sql.backup".format(**con))
    start_path = os.getcwd()
    db_backup = "{}/../../db_backup".format(path)
    try:
        os.chdir(db_backup)
    except:
        os.mkdir(db_backup)
        os.chdir(db_backup)
    call("mysql --user={user} --password={pass} --host={host} {name} < {name}.sql.backup".format(**con), shell=True)
    os.chdir(start_path)
    print "finished!\n"


# Cry
def activate_preview(customer_ID):
    path = get_customer_path(customer_ID)
    f = open("{}/wp-config.php".format(path), 'ar+')
    siteurl = siteurl_from_path(path)
    f.seek(0, 2)
    f.write("define('WP_HOME','{}.crystonepreview.net');\n".format(siteurl_from_path(path)))
    f.write("define('WP_SITEURL','{}.crystonepreview.net');\n".format(siteurl_from_path(path)))
    # siteurl = siteurl_from_path(path)
    # preview_adress = "{}.crystonepreview.net".format(siteurl)
    # raw_input("change siteurl from {} to {}".format(siteurl, preview_adress))
    # change_siteurl(path, siteurl, preview_adress)


# assumes path is domainname.tld/*/
def siteurl_from_path(path):
    return os.path.basename(os.path.normpath("{}/../".format(path)))
    # old_siteurl = re.search("/storage/content/[0-9]{2}/[0-9]{7}/([^/]+)", old_path).group(1)


# assumes wp-config and wp-content in path
def change_siteurl(path, old_siteurl, new_siteurl=""):
    backup(path)
    if new_siteurl == "":
        new_siteurl = "www.{}".format(siteurl_from_path(path))
    # raw_input(new_siteurl)
    con = get_connection_string("{}/wp-config.php".format(path))
    sql = download_sql(con)
    sub_patterns = []
    sub_patterns.append(["{}".format(old_siteurl), new_siteurl])
    sub_patterns.append(["('upload_path',)'[^']*'", r"\1'{}/wp-content/uploads'".format(path)])
    raw_input(sub_patterns)
    for line in fileinput.input(sql, inplace=True):
        for pattern in sub_patterns:
            line = re.sub(pattern[0], pattern[1], line)
        print line,
    upload_sql(con)
    os.remove(sql)


def move(old_path, new_path):
    if old_path == "" or new_path == "":
        return
    old_siteurl = siteurl_from_path(old_path)
    new_siteurl = siteurl_from_path(new_path)
    call("mkdir {}/../{}.old".format(new_path, new_siteurl), shell=True)
    raw_input("moving all files from {0}/* to {0}/../{1}.old/".format(new_path, new_siteurl))
    call("mv {0}/* {0}/../{1}.old/".format(new_path, new_siteurl), shell=True)
    raw_input("copying all files from {}/* to {}/".format(old_path, new_path))
    call("rsync -az {}/ {}/ ".format(old_path, new_path), shell=True)
    call("rsync -az {}/ {}/ ".format(old_path, new_path), shell=True)
    change_siteurl(new_path, old_siteurl)


def backup(path):
    con = get_connection_string("{}/wp-config.php".format(path))
    sql = download_sql(con)
    db_backup = "{}/../../db_backup/".format(path)
    backup = os.path.normpath("{}{}.backup".format(db_backup, sql))
    try:
        os.rename(sql, backup)
    except:
        os.mkdir(db_backup)
        os.rename(sql, backup)
    print "backup {} taken".format(backup)
