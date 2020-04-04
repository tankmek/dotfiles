#!/bin/env python3

import crypt
import getpass 

# creates a sha512 password for use with linux
# slackware's mkpasswd does not work the same as debian/redhat
print(crypt.crypt(getpass.getpass(), crypt.mksalt(crypt.METHOD_SHA512)))

