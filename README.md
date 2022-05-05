# webapp_backup

A set of generic scripts for web application backups.

Most web applications store their data in a relational database plus a small number of directories.
The database locatin, username, and password, as well as the data directories can be deduced from the web application's settings.

This repository contains scripts which get the necessary data from the application settings and then create a backup at some destination.
The destination can then be backed up by an appropriate backup solution, such as [Bareos](https://github.com/bareos/bareos).
