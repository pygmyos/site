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
                displayNavbar($page_id);
            ?>
            <div id="content">
                <p>We will have a full official release sometime
                    soon. Until then, you can download the most current stable code base <a href="http://code.google.com/p/pygmyos/downloads/detail?name=PygmyOS%20Stable%202-23-12.zip">here</a>
                    and browse the source repositories <a href="http://code.google.com/p/pygmyos/wiki/Source?tm=4">here</a>.</p>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>