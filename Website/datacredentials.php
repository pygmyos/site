<?php

/* The actual login for our server has been removed
 * and replaced with a login to a local dev server
 */

$datalink = mysql_connect('localhost:3306', 'root', '')
        or die('Could not connect: ' . mysql_error());

$masterpassword = 'password';
?>