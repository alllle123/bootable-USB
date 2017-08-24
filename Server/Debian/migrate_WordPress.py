#!/usr/bin/env python

from subprocess import call
from urllib
import argparse
import re
from tld import get_tld

def fill_in_template(template, data):
    for key, value in data.items():
        template = template.replace("<{}>".format(key), str(value))
    return template

def fill_file(data, filename):
    content = open(filename, 'r').read()
    content = fill_in_template(data, content)
    open(filename, 'w').write(content)

def get_github_file(filename):
    opener = urllib.URLopener()
    opener.retrieve("{}/{}".format(github_url, filename), filename)

github_url = "https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/Debian/"

get_github_file("wordpress.sql")
get_github_file("setup.sh")
get_github_file("migration_credentials.txt")
get_github_file("add_vhost.sh")
get_github_file("WordPress.py")

import WordPress

subprocess.call("setup.sh")

input_format = ["Site", "ID", "IP_FTP", "Password_FTP", "Password_WP"]
data = {}

for info in input_format:
    data[info] = raw_input("{}:".format(info))

domain = get_tld("http://{Site}".format(**data), as_object=True)
data["Domain"] = domain.domain

call("add_vhost.sh", data["Site"])
call(["wget", "-nH", "-r", "-l", "0", "ftp://{FTP}/{Site}/public_html".format(**data),
      "--user={ID}_staff".format(**data), "--password={Password}".format(**data),
      "-P", "/var/www/{Site}/public_html".format(**data)])

fill_file("wordpress.sql", data)
fill_file("migration_credentials.txt", data)
call(["mysql", "<", "wordpress.sql"])
WordPress.fix_migrated_sites()

