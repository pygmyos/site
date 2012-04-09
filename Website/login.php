<?php
    $page_id = "home";
    require("components.php");
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php loadHead("Home"); ?>
    </head>
    <body id=<?php echo "'$page_id'" ?>>
        <div id="container">
            <?php
                displayHeader();
                displayNavbar($page_id);
                displayCarousel(array("images/boards/Nebula1.jpg"));
            ?>
            <div id="content">
                <h4>
                    Login</h4>
                <p>
                    <form>
                        <input type="text"></input>
                    </form>
                </p>
                
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>