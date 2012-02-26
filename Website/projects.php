<?php
    $page_id = "projects";
    require("components.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php loadHead("Projects"); ?>
    </head>
    <body id=<?php echo $page_id ?>>
        <div id="container">
            <?php
                displayHeader();
                displayNavbar($page_id);
            ?>
            <div id="content">
                <p>We are working on documentation for all Pygmy related projects. Until then, you can view the progress of some of our projects on our 
                    <a href="http://code.google.com/p/pygmyos/source/browse/?repo=projects">project repository</a>.</p>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>