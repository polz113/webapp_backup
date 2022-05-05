#!/bin/sh

if [ -z "$1" ]; then
    help="
Get database and other parameters from a PHP app config

Usage:
$argv[0] <app_directory> <property>

Where app_directory is the location of your application and property is one of:
  - dbtype
  - dbpassword
  - dbuser
  - dbname
  - dbhost
  - datadir
  - enter_maintenance_cmd
  - exit_maintenance_cmd
"

    echo "${help}"
    exit 1;
fi

app_directory=$1

. $app_directory/.env


if [ -z "$2" ]; then
    echo "VSEEEEEee"
    exit 0
fi
case $2 in 
    dbtype) echo mysql;;
    dbpassword) echo $DB_PASSWORD;;
    dbuser) echo $DB_USERNAME;;
    dbname) echo $DB_DATABASE;;
    dbhost) echo $DB_HOST;;
    datadir) echo $1/storage;;
    enter_maintenance_cmd) echo true;;
    exit_maintenance_cmd) echo true;;
    *) exit 1;;
esac
