#!/bin/bash

# Run Postfix
/usr/sbin/postfix start

# Run MariaDB
/usr/bin/mysqld_safe --timezone=${DATE_TIMEZONE}&

# Start Apache
/usr/sbin/apachectl -DFOREGROUND -k start -e debug

/bin/bash