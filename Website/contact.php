<?php   $page_id = "contact";
        require("components.php"); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <?php loadHead("Contact"); ?>
</head>
<body id=<?php echo $page_id ?>>
    <div id="container">
        <?php   displayHeader();
                displayNavbar(); ?>
        <div id="content">
            <h4>Questions or constructive criticism regarding the site</h4>
            <p>Contact our site administrator at <a href="mailto:teitelmanevan@gmail.com">teitelmanevan@gmail.com</a></p>
            <h4>Questions or suggestions regarding PygmyOS or Pygmy boards</h4>
            <p>Contact us at <a href="mailto:support@pygmy-os.com">support@pygmy-os.com</a></p>
        </div>
        <?php displayFooter(); ?>
    </div>
</body>
</html>