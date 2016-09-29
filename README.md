# homebank

web frontend to homebank

Features:

 * add new operations (responsive design interface) to homebank file
 * display last operations
 * select operation category from list

Pre-requisites:

 * homebank file
 * Unix system
 * Apache + perl

## Installation

On Apache > 2.4, set this configuration:

```
Alias /homebank /var/www/homebank
<Directory /var/www/homebank>
           Options +Indexes +FollowSymLinks +MultiViews +ExecCGI
           AddHandler cgi-script .pl

           AllowOverride None
           Require all granted
</Directory>
```

## Configuration

Fill some variables in variables section in index.pl:

```
$homebank_file      --> homebank file path from which are read operations and categories
$fileout            --> written homebank file when an operation is saved (generally, same as above)
$account            --> account associated to new saved operations
$max_operations     --> maximum number of displayed operations in the interface
```


