#!/bin/sh

# Variables


WEBAPP_TYPE=$1
WEBAPP_DIR=$2
BACKUP_DIR=$3

if [ -z "$1" ]; then
    help="
Create snapshot, dump database.

Usage:
$0 <app_type> <app_directory> <backup_destination>

Supported databases:
  - mysql
  - postgresql

Supported filesystems:
  - btrfs
"
    echo $help;
    exit 1;
fi

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [ -f "$SCRIPT_DIR/get_${WEBAPP_TYPE}_config" ]; then
    GWC="$SCRIPT_DIR/get_${WEBAPP_TYPE}_config \"${WEBAPP_DIR}\""
else
    echo "App type ${WEBAPP_TYPE} not supported";
    exit 1;
fi

# GWC="get_web_config $WEBAPP_DIR"

DATA_DIR=$($GWC datadir)
SNAPSHOT_DIR="$BACKUP_DIR"
DB_DUMP_DIR="$BACKUP_DIR"
DB_DUMP_NAME=$($GWC dbname).sql
SNAPSHOT_NAME="moodledata"

# Enter maintenance mode
$($GWC enter_maintenance_cmd)
# Delete possible old snapshot
btrfs subvolume delete "${SNAPSHOT_DIR}/${SNAPSHOT_NAME}"
# Create FS snapshot
echo btrfs subvolume snapshot –r "$DATA_DIR" "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
btrfs subvolume snapshot -r "$DATA_DIR" "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
# Start DB dump in background

case $($GWC dbtype) in
    mysql) 
        mysql -h $($GWC dbhost) --user $($GWC dbuser) --password $($GWC dbpassword) --result-file "$DB_DUMP_DIR/$DB_DUMP_NAME" $($GWC dbname) &
    ;;
    postgresql)
        export PGPASSWORD=$($GWC dbpassword)
        pg_dump -h $($GWC dbhost) -U $($GWC dbuser) -f "$DB_DUMP_DIR/$DB_DUMP_NAME" $($GWC dbname) & ;;
    *)
        echo "Unsupported database"
        exit 1
    ;;
esac
# Exit maintenance mode
$($GWC exit_maintenance_cmd)
# Wait for dump to finish
wait
# You can now download the created backup files


