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
                    About</h4>
                <p>
                    PygmyOS is an operating system originally intended for the MSP430 series of microcontrollers. It has
                    since outgrown the MSP430 and is now primarily intended for ARM, specifically the STM32
                    and other similar CortexM3 core MCUs. PygmyOS was built from the ground up to be quick and flexible 
                    with code that is both user and MCU friendly.
                </p>
                <h4>
                    Current status</h4>
                <p>
                    PygmyOS is still a young project. We will have a full official release sometime
                    soon. Until then, you can download the most current stable code base <a href="http://code.google.com/p/pygmyos/downloads/detail?name=PygmyOS%20Stable%202-23-12.zip">here</a>
                    and browse the source repositories <a href="http://code.google.com/p/pygmyos/wiki/Source?tm=4">here</a>.
                </p>
                <h4>
                    Features</h4>
                <p>
                    <ul>
                        <li>Multitasking</li>
                        <li>Inter-process messaging</li>
                        <li>Command interface with queuing</li>
                        <li>Real Time Clock with calender</li>
                        <li>Stopwatch for process timing</li>
                        <li>Nested Vector Interrupt Controller interface simplifies interrupt driven application
                            development</li>
                        <li>Substantial software and hardware USART, I2C, SPI, and parallel support Extensible
                            FIFO and stream support</li>
                        <li>Formatted output</li>
                        <li>Advanced Pygmy Data Integrity Algorithm integrated with formatted output</li>
                        <li>Simple enough for a beginner to use</li>
                    </ul>
                </p>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>