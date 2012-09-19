<?php
    /* Page accepts 'table' and 'password' as parameters
     * Password is checked against the masterpassword in datacredentials.php
     * Each column name is displayed with an input field next to it, allowing the user to input a new row into the table */

    //Database credentials
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
        setcookie("validation", $passed_password, 0, '', '', false, true);
    }

    //Page setup
    $page_id = "datafill";
    //Contains the page components (header, content, footer, etc)
    require("components.php");
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php
            loadHead("Datafill");
        ?>
    </head>
    <body id=<?php echo "'$page_id'" ?>>
        <div id="container">
            <?php
                //Page components
                displayHeader();
                displayNavbar();
            ?>
            <div id="content" style="padding: 18px 18px 0 18px;">
                <noscript><div class="notification">This page does not work without Javascript enabled.</div></noscript>
                <?php
                    //Checks for correct password input or password cookie
                    if ($isPasswordValidated || $isCookieValidated)
                    {
                        //Checks to see if the input is submitted. If so, loads the values to the database and refreshes to clear the page arguments with "Refresh" as the submit argument and with a timestamp so we can display a confirmation message
                        if (filter_input(INPUT_GET, 'submit', FILTER_SANITIZE_SPECIAL_CHARS) == "Submit")
                        {
                            //Lets the user know that the page is submitting the data
                            echo "<p>Submitting data...</p>";

                            //Gets the column names from the current table
                            $query = "SELECT column_name, column_type FROM INFORMATION_SCHEMA.columns WHERE table_name='" . mysql_real_escape_string($passed_table) . "'";
                            //Sends the query to the sql server and loads the results into $result
                            $result = mysql_query($query) or die('Query failed: ' . mysql_error());
                            //Gets the total number of columns returned
                            $numColumns = mysql_num_rows($result);

                            //Checks to make sure the query returned results
                            if ($numColumns > 0)
                            {
                                //Column attributes for the insert command
                                $columnNames = array();
                                $columnValues = array();

                                //Loads the column names and values into arrays
                                $i = 0;
                                while ($column = mysql_fetch_array($result, MYSQL_ASSOC))
                                {
                                    //Gets the current column name
                                    $columnName = strToLower($column["column_name"]);
                                    //Gets the current column type
                                    $columnType = strToLower($column["column_type"]);

                                    //Gets the value of the current column from the page arguments
                                    $columnValue = filter_input(INPUT_GET, $columnName, FILTER_SANITIZE_SPECIAL_CHARS);
                                    if ($columnValue != null && $columnValue != "")
                                    {
                                        //Loads the current column name into the array
                                        $columnNames[$i] = mysql_real_escape_string($columnName);
                                        //Loads the current column value into the array with quotes around it if it's a string
                                        if (strContains($columnType, "int"))
                                        {
                                            $columnValues[$i] = mysql_real_escape_string($columnValue);
                                        }
                                        else
                                        {
                                            $columnValues[$i] = "'" . mysql_real_escape_string($columnValue) . "'";
                                        }
                                    }
                                    $i++;
                                }
                                unset($i);

                                //Insert the values into the database based on the column names
                                $query = "INSERT INTO " . mysql_real_escape_string($passed_table) . " (" . implode(", ", $columnNames) . ") VALUES (" . implode(", ", $columnValues) . ")";
                                ////Sends the query to the sql server and loads the results into $result
                                mysql_query($query) or die('Query failed: ' . mysql_error() . '\nCode: ' . $query);

                                //Refresh the page to clear the page arguments
                                echo "<script>window.location=\"datafill.php?submit=Refresh&timestamp=" . date('h:i:s A') . "&table=$passed_table\";</script>";
                            }
                            else
                            {
                                //Displays an error notification if the table is not valid
                                echo "<div id='table_error' class='notification'>\nInvalid table</div>\n";
                            }
                            //Frees up the result set
                            mysql_free_result($result);
                        }

                        //Check to see if the page is receiving a refresh and displays a confirmation message
                        else if (filter_input(INPUT_GET, 'submit', FILTER_SANITIZE_SPECIAL_CHARS) == "Refresh")
                        {
                            $dataTimestamp = filter_input(INPUT_GET, 'timestamp', FILTER_SANITIZE_SPECIAL_CHARS);
                            echo "<div id='input_result' class='notification'>\nNew data added to the table '$passed_table' at $dataTimestamp</div>\n";
                        }
                        //Begins the input form
                        echo "<form name='data_input'>\n";

                        //Gets all of the table names in the database
                        $query = "SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_schema='" . mysql_real_escape_string($database_name) . "'";
                        //Sends the query to the sql server and loads the results into $result
                        $result = mysql_query($query) or die('Query failed: ' . mysql_error());
                        ?>

                        <script type="text/javascript">
                            //Refreshes the page with the selected table
                            function refreshFromDropdown()
                            {
                                //Selects the table drop-down list
                                var e = document.getElementById("table_dropdown");
                                //Gets the selected table name from the drop-down list
                                var table_name = e.options[e.selectedIndex].text;
                                //Refreshes the page with the selected table
                                window.location="datafill.php?table=" + table_name.toLowerCase();
                            }
                        </script>

                        <?php
                        //Starts the table drop-down list
                        echo "<select name='table' onchange='refreshFromDropdown()' id='table_dropdown' style='margin-bottom: 10px;'>";

                        //The default blank option if a table is not selected
                        echo "<option value=''></option>";

                        //Cycles through the rows for each table and loads its name into the drop down list
                        while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                        {
                            //Gets the table name
                            $table_name = strtolower($line["table_name"]);
                            //Starts the option
                            echo "<option value='" . $table_name . "'";

                            //Selects the current table
                            if ($table_name == $passed_table)
                            {
                                echo " selected='selected'";
                            }
                            //Puts the option text and closes the option
                            echo ">" . ucwords($table_name) . "</option>\n";
                        }
                        //Ends the drop-down list
                        echo "</select>\n";

                        //Gets the column names from the current table
                        $query = "SELECT column_name, is_nullable, column_type, extra FROM INFORMATION_SCHEMA.columns WHERE table_name='" . mysql_real_escape_string($passed_table) . "'";
                        //Sends the query to the sql server and loads the results into $result
                        $result = mysql_query($query) or die('Query failed: ' . mysql_error());
                        //Gets the total number of tables returned
                        $numColumns = mysql_num_rows($result);

                        //Checks to make sure the query returned results
                        if ($numColumns > 0)
                        {
                            //HTML table for inputs and column names
                            echo "<table style='margin-bottom: 10px;' class='soft_table'>\n";
                            //Cycles through SQL table rows and loads each row's column values into the associative array "$line"
                            while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                            {
                                //Items used multiple times4
                                $column_type = strToLower($line["column_type"]);
                                $column_name = strToLower($line["column_name"]);

                                //Skips column if it auto_increments
                                if (strContains($line["extra"], 'auto_increment'))
                                {
                                    continue;
                                }
                                //Starts html table row
                                echo "\t<tr>\n";
                                //Start html table column and put the column name in it
                                echo "\t\t<td style='text-align: right; border-right: 1px solid #e8edff;'>" . $line["column_name"];
                                //If the column is required, puts an asterix next to it
                                if ($line["is_nullable"] == 'NO')
                                {
                                    echo "*";
                                }
                                //Closes the html table column
                                echo "\n</td>\n";

                                //Starts the next column (for the inputs)
                                echo "\t\t<td>\n";

                                //Checks the column data type for enum types
                                if (strContains($column_type, "enum"))
                                {
                                    //Extracts the enum items from the column type
                                    $enumItems = getSqlEnumItems($column_type);
                                    //Drop-down list with the enum items
                                    echo "<select name='$columnName'>\n";
                                    //Adds the default blank option
                                    echo "<option value=''></option>";

                                    //Cycles through the enum items
                                    foreach ($enumItems as $enumItem)
                                    {
                                        echo "<option value='$enumitem'>" . ucwords($enumItem) . "</option>";
                                    }
                                    //Removes the $enumItem variable
                                    unset($enumItem);
                                    //Closes enum drop-down list
                                    echo "</select></td></tr>\n";
                                }
                                //Checks the column data type for the bit type
                                else if (strContains($column_type, "bit"))
                                {
                                    //Radio buttons, Yes or no
                                    echo "<input type='radio' name='$column_name' value='1' /> Yes";
                                    echo "<input type='radio' name='$column_name' value='0'  style='margin-left: 10px;' /> No</td></tr>";
                                }
                                //Checks the column data type for the date type
                                else if (strContains($column_type, "date"))
                                {
                                    //Text box with the date format to its right
                                    echo "<input type='text' name='$column_name' value='' /></td><td style='padding-left: 6px;'>YYYY-MM-DD</td></tr>\n";
                                }
                                //Checks the column data type for all other types including int and text data types
                                else
                                {
                                    //Text box
                                    echo "<input type='text' name='$column_name' /></td></tr>\n";
                                }
                            }
                            //Closes the html table
                            echo "</table>\n";

                            //Submit button
                            echo "<input type='submit' name='submit' value='Submit' style='margin-bottom:18px;' class='button' />\n";
                            //Closes the form
                            echo "</form>\n";
                            //A note to let the user know which items are required
                            //echo "<p>Items marked with * are required</p>\n";
                        }
                        else
                        {
                            //Displays a message asking the user to select a table
                            echo "<div class='notification'>Please select a table</div>\n";
                        }

                        //Frees up the result set
                        mysql_free_result($result);

                        //Closes data link
                        mysql_close($datalink);
                    }
                    else
                    {
                        //If the password is invalid or the user is not cookie validated, display this
                        echo "<div class='notification' style='margin-bottom: 18px;'>Invalid password</div>";
                    }
                ?>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>