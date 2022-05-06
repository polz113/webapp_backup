#!/usr/bin/php
<?php
// 
//
/**
 * This script outputs the parameters of a web app
 *
 * @copyright  2021 UL FRI
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */



$help = <<<EOL
Get database and other parameters from a PHP app config

Usage:
$argv[0] <app_directory> <property>

Where app_directory is the location of your moodle and property is one of:
  - dbtype
  - dbpassword
  - dbuser
  - dbname
  - dbhost
  - datadir
  - enter_maintenance_cmd
  - exit_maintenance_cmd

EOL;

if (sizeof($argv) < 1) {
    echo $help;
    exit(0);
}

$app_directory = $argv[1];

define('CLI_SCRIPT', 1);
require($app_directory . '/config.php');

$params = [];

switch($app_type){
    case "moodle":
        $params = array(
            "dbtype" => $CFG->dbtype,
            "dbpassword" => $CFG->dbpass,
            "dbuser" => $CFG->dbuser,
            "dbname" => $CFG->dbname,
            "dbhost" => $CFG->dbhost,
            "datadir" => $CFG->dataroot,
            "enter_maintenance_cmd" => "php " . $app_directory . "/admin/cli/maintenance.php --enable",
            "exit_maintenance_cmd" => "php " . $app_directory . "/admin/cli/maintenance.php --disable",
        );
    break;
}

if (sizeof($params) == 0){
    echo "Could not extract parameters for $app_type at $app_directory\n";
}

if (sizeof($argv) < 3){
    var_dump($params);
} else {
    $property = $argv[2];
    echo $params[$property];
}

?>
