#!/bin/sh

# Variables



WEBAPP_DIR=$1
BACKUP_DIR=$2

GWC="get_web_config.php moodle $WEBAPP_DIR"

DATA_DIR=$($GWC datadir)
SNAPSHOT_DIR="$BACKUP_DIR"
DB_DUMP_DIR="$BACKUP_DIR"
DB_DUMP_NAME=$($GWC dbname).sql
SNAPSHOT_NAME="moodledata"

# Enter maintenance mode
$($GWC enter_maintenance_cmd)
# Delete possible old snapshot
btrfs subvolume delete "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
# Create FS snapshot
echo btrfs subvolume snapshot –r "$DATA_DIR" "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
btrfs subvolume snapshot -r "$DATA_DIR" "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
# Start DB dump in background
export PGPASSWORD=$($GWC dbpassword)
pg_dump -h $($GWC dbhost) -U $($GWC dbuser) -f "$DB_DUMP_DIR/$DB_DUMP_NAME" $($GWC dbname) &
# Exit maintenance mode
$($GWC exit_maintenance_cmd)
# Wait for dump to finish
wait
# You can now download the created backup files


