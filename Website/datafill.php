<?php
/* Page accepts 'table' and 'password' as parameters
 * Password is checked against the masterpassword in datacredentials.php
 * Each column name is displayed with an input field next to it, allowing the user to input a new row into the table */

//Page setup
$page_id = "datafill";
//Contains the page components (header, content, footer, etc)
require("components.php");

//Database
require('datacredentials.php');
//Selects the database specified in datacredentials.php on the mysql link initiated in datacredentials.php
mysql_select_db($database_name) or die('Could not select database');

//Gets the passed tablename from the page arguments
$passed_table = strtolower(filter_input(INPUT_GET, 'table', FILTER_SANITIZE_SPECIAL_CHARS));

//Password validation
//Gets the password from the page arguments
$passed_password = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
//Checks for password validation
$isPasswordValidated = $passed_password == $masterpassword;
//Checks for cookie validation
$isCookieValidated = array_key_exists("validation", $_COOKIE) ? $_COOKIE["validation"] == $masterpassword : false;
//Sets cookie if the user is not already cookie validated and is password validated
if (!$isCookieValidated && $isPasswordValidated)
{
    setcookie("validation", $password, 0, '', '', false, true);
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
            //Page components
            displayHeader();
            displayNavbar();
            ?>
            <div id="content">
                <?php
                //Checks for correct password input or password cookie (not very secure at the moment)
                if ($isPasswordValidated || $isCookieValidated)
                {
                    //Begins the input form
                    echo "<form>\n";

                    //Gets all of the table names in the database
                    $query = "SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_schema='$database_name'";
                    //Sends the query to the sql server and loads the results into $result
                    $result = mysql_query($query) or die('Query failed: ' . mysql_error());

                    //A script to read the table name from the drop-down list
                    ?>
                    <script type="text/javascript">
                        function refreshFromDropdown()
                        {
                            var e = document.getElementById("table_dropdown");
                            var table_name = e.options[e.selectedIndex].text; 
                            window.location="datafill.php?table=" + table_name;
                        }
                    </script>
                    <?php
                    //Starts the table drop-down list
                    echo "<select onchange='refreshFromDropdown()' id='table_dropdown' style='margin-bottom: 10px;'>";
                    //Cycles through the rows for each table and loads its name into the drop down list
                    while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                    {
                        $table_name = strtolower($line["table_name"]);
                        echo "<option value='" . $table_name . "'";
                        if ($table_name == $passed_table)
                        {
                            echo " selected='selected'";
                        }
                        echo ">" . ucwords($table_name) . "</option>\n";
                    }
                    //Ends the drop-down list
                    echo "</select>\n";

                    //Gets the column names from the table passed to the URL
                    $query = "SELECT column_name, is_nullable, data_type, column_type FROM INFORMATION_SCHEMA.columns WHERE table_name='" .
                            $passed_table . "'";
                    //Sends the query to the sql server and loads the results into $result
                    $result = mysql_query($query) or die('Query failed: ' . mysql_error());

                    //HTML table for inputs and column names
                    echo "<table style='margin-bottom: 5px;'>\n";
                    //Cycles through SQL table rows and loads each row's column values into the associative array "$line"
                    while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                    {
                        //Starts html table row
                        echo "\t<tr>\n";
                        //Start html table column and put the column name in it
                        echo "\t\t<td style='padding-right: 10px; padding-bottom: 5px; text-align: right;'>" . $line["column_name"];
                        //If the column is required, puts an asterix next to it
                        if ($line["is_nullable"] == 'NO')
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
                    //If the password is invalid or the user is not cookie validated, display this
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