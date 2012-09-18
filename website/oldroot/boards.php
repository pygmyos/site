<?php
    $page_id = "boards";
    require("components.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <?php loadHead("Boards"); ?>
    </head>
    <body id=<?php echo $page_id ?>>
        <div id="container">
            <?php
                displayHeader();
                displayNavbar($page_id);
            ?>
            <div id="content">
                <h4>
                    Nebula Features</h4>
                <p>
                    <ul>
                        <li>2” round board outline</li>
                        <li>Straight headers with 25 general purpose IO pins
                            <ul class="nomargin"">
                                <li>Master clock out, timer pin</li>
                                <li>2 USART TX/RX pairs, digital pins</li>
                                <li>4 Timer pins</li>
                                <li>2 Time/Analog pins</li>
                                <li>8 Analog pins</li>
                                <li>2 DAC ( Digital to Analog Converter ) pins</li>
                                <li>3.3V Power</li>
                                <li>5V Input</li>
                                <li>Battery</li>
                                <li>GND</li>
                            </ul>
                        </li>
                        <li>STM32F100 24MHz, STM32F103 72MHz</li>
                        <li>Cutting edge ARM Cortex M3</li>
                        <li>2.4GHz RF</li>
                        <li>LiPo battery charge and management</li>
                        <li>On-board power regulation</li>
                        <li>Support for PygmyOS</li>
                        <li>Integrated bootloader</li>
                        <li>4MB Flash with filesystem</li>
                        <li>Precision temperature sensor</li>
                    </ul>
                </p>
            </div>
            <?php displayFooter(); ?>
        </div>
    </body>
</html>