<?php
//Page accepts 'table' and 'password' as parameters
//Password is checked against the masterpassword in datacredentials.php
//Each column name is displayed with an input field next to it, allowing the user to input a new row into the table
//Page setup
$page_id = "datafill";
require("components.php");

//Database
require('datacredentials.php');
mysql_select_db('pygmydata') or die('Could not select database');

//Password validation
$password = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$isPasswordValidated =  $password == $masterpassword;
$isCookieValidated = array_key_exists("validation", $_COOKIE) ? $_COOKIE["validation"] == $masterpassword : false;
if(!$isCookieValidated)
{
    setcookie("validation", $password);
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php 
            loadHead("Datafill");
        ?>
    </head>
    <body id=<?php echo $page_id ?>>
        <div id="container">
            <?php
                displayHeader();
                displayNavbar();
            ?>
            <div id="content">
                <?php
                //Checks for correct password input or password cookie (not very secure at the moment)
                if($isPasswordValidated || $isCookieValidated)
                {
                    //Gets the column names from the table passed to the URL
                    $query = "select column_name, is_nullable, data_type, column_type from INFORMATION_SCHEMA.columns WHERE table_name='" . 
                            filter_input(INPUT_GET, 'table', FILTER_SANITIZE_SPECIAL_CHARS) . "'";
                    //Queries the SQL server
                    $result = mysql_query($query) or die('Query failed: ' . mysql_error());

                    //Input form
                    echo "<form>\n<table style='margin-bottom: 5px;'>\n";
                    //Cycles through SQL table rows and loads each row's column values into the associative array "$line"
                    while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                    {
                        //Starts html table row
                        echo "\t<tr>\n";
                        //Start html table column and put the column name in it
                        echo "\t\t<td style='padding-right: 10px; padding-bottom: 5px; text-align: right;'>" . $line["column_name"];
                        //If the column is required, puts an asterix next to it
                        if ($line["is_nullable"] == 0)
                        {
                            echo "*";
                        }
                        //Puts a colon at the end and closes the html table column
                        echo ":\n</td>\n";

                        //Starts the next column (for the inputs)
                        echo "\t\t<td>\n";
                        //Checks the column data type and puts the appropriate input in the column
                        if (strstr($line["data_type"], "text") || strstr($line["data_type"], "int"))
                        {
                            echo "<input type='text' name='" . $line["column_name"] . "' />";
                        }
                        //Closes the column
                        echo "</td>\n";
                        //Closes the row
                        echo "\t</tr>\n";
                    }
                    //Closes the table
                    echo "</table>\n";

                    //Submit button
                    echo "<input type='submit' name='submit' value='Submit'/>";
                    //Closes the form
                    echo "</form>\n";
                    //A note to let the user know which items are required
                    echo "<p style='margin-top: 15px;'>Items marked with '*' are required</p>";

                    //Frees up the result set
                    mysql_free_result($result);
                }
                else
                {
                    echo "<p>Invalid password</p>";
                }
                
                //Closes data link
                mysql_close($datalink);
                ?>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>