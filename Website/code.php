<?php
$page_id = "code";
require("components.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php loadHead("Code"); ?>
    </head>
    <body id=<?php echo $page_id ?>>
        <div id="container">
            <?php
            displayHeader();
            displayNavbar();
            ?>
            <div id="content">

            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>