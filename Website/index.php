<?php   $page_id = "home";
        require("components.php"); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <?php loadHead("Home"); ?>
</head>
<body id=<?php echo $page_id ?>>
    <div id="container">
        <?php   displayHeader();
                displayNavbar();
                displayCarousel(array("images/boards/Nebula1.jpg")); ?>
        <div id="content">
            <h4>
                Current status</h4>
            <p>
                PygmyOS is still a young project. We will have a full official release sometime
                soon. Until then, you can download our current source from one of our <a href="http://code.google.com/p/pygmyos/wiki/Source?tm=4">
                    repositories</a>.
            </p>
            <br />
            <h4>
                About</h4>
            <p>
                PygmyOS is an operating system originally intended for the MSP430 series. It has
                since outgrown the MSP430 and is now primarily intended for ARM, specifically STM32
                and other similar CortexM3 core MCUs. It is quick, flexible, and user friendly.
                Pygmy is built from the ground up with code that is both user and MCU friendly.
            </p>
            <br />
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
            <br />
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