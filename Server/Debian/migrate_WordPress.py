#!/usr/bin/env python

from subprocess import call
from urllib
import argparse
import re

def fill_in_template(template, data):
    for key, value in data.items():
        template = template.replace("<{}>".format(key), str(value))
    return template

opener = urllib.URLopener()
opener.retrieve("https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/Debian/wordpress.sql", "wordpress.sql")
opener.retrieve("https://github.com/Kabix1/bootable-USB/blob/master/Server/Debian/setup.sh", "test_setup.sh")
subprocess.call("setup.sh")

input_format = ["Site", "ID", "FTP", "Password"]
data = {}

for info in input_format:
    data[info] = raw_input("{}:".format(info))

opener.retrieve("https://github.com/Kabix1/bootable-USB/blob/master/Server/Debian/add_vhost.sh", "add_vhost_test.sh")
call("add_vhost.sh", data["Site"])
call(["wget", "-nH", "-r", "-l", "0", "ftp://{FTP}/{Site}/public_html".format(**data),
                "--user={ID}_staff".format(**data), "--password={Password}".format(**data),
      "-P", "/var/www/{Site}/public_html".format(**data)])

database = open("wordpress.sql", "r").read()
database = fill_in_template(database, data)
open("wordpress.sql", "w").write(database)
call(["mysql", "<", "wordpress.sql"])
