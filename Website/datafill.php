<?php
//Page setup
$page_id = "datafill";
require("components.php"); 

//Database
require('datacredentials.php');
mysql_select_db('pygmydata');// or die('Could not select database');
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <?php loadHead("Datafill"); ?>
</head>
<body id=<?php echo $page_id ?>>
    <div id="container">
        <?php   displayHeader();
                displayNavbar();
        ?>
        <div id="content">
            <?php
                   // I will hold on hope, see the world hanging upside down
                $query = "select table_name from INFORMATION_SCHEMA.tables";
                $result = mysql_query($query) or die('Query failed: ' . mysql_error());
                echo "<table>\n";
                while ($line = mysql_fetch_array($result, MYSQL_ASSOC))
                {
                    echo "\t<tr>\n";
                    foreach ($line as $col_value) 
                    {
                        echo "\t\t<td>$col_value</td>\n";
                    }
                    echo "\t</tr>\n";
                }
                echo "</table>\n";
                mysql_free_result($result);
                mysql_close($datalink);
            ?>
        </div>
        <?php displayFooter(); ?>
    </div>
</body>
</html>