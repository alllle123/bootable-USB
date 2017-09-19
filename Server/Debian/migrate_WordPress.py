#!/usr/bin/env python

import subprocess
import urllib
import argparse
import re
from tld import get_tld

def fill_in_template(template, data):
    for key, value in data.items():
        template = template.replace("<{}>".format(key), str(value))
    return template

def fill_file(filename, data):
    content = open(filename, 'r').read()
    content = fill_in_template(content, data)
    open(filename, 'w').write(content)

def get_github_file(filename):
    opener = urllib.URLopener()
    opener.retrieve("{}/{}".format(github_url, filename), filename)

github_url = "https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/Debian/"

get_github_file("wordpress.sql")
get_github_file("migration_credentials.txt")
get_github_file("add_vhost.sh")
get_github_file("WordPress.py")
get_github_file("setup_LAMP.sh")
get_github_file("setup_ftp.sh")
get_github_file("create_ftp_user.sh")

import WordPress

subprocess.call(["bash", "setup_LAMP.sh"])

input_format = ["Site", "ID", "IP_FTP", "Password_FTP", "Password_WP", "Old_DB"]
data = {}

for info in input_format:
    data[info] = raw_input("{}:".format(info))

domain = get_tld("http://{Site}".format(**data), as_object=True)
data["Domain"] = domain.domain

subprocess.call(["bash", "add_vhost.sh", data["Site"]])
subprocess.call(["wget", "-nH", "-r", "-l", "0", "--cut-dirs=2", "ftp://{IP_FTP}/{Site}/public_html".format(**data),
      "--user={ID}_staff".format(**data), "--password={Password_FTP}".format(**data),
      "-P", "/var/www/{Site}/public_html".format(**data)])
subprocess.call(["wget", "-nH", "ftp://{IP_FTP}/{Old_DB}.sql".format(**data),
      "--user={ID}_staff".format(**data), "--password={Password_FTP}".format(**data),
      "-P", "/root/"])
fill_file("wordpress.sql", data)
fill_file("migration_credentials.txt", data)
subprocess.call("mysql < wordpress.sql", shell=True)
WordPress.fix_migrated_sites()
subprocess.call("mysql {Domain} < {Old_DB}.sql".format(**data), shell=True)
subprocess.call(["bash", "setup_ftp.sh"])
subprocess.call(["bash", "create_ftp_user.sh", "{Domain}".format(**data)])
