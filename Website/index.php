<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PygmyOS | Home</title>
    <link rel="Stylesheet" type="text/css" href="styles/style.css" />
    <style type="text/css">
        #header
        {
            background-color: #FFFFFF;
            height: auto;
            margin: 0;
        }
        #head_title
        {
            display: inline;
            position: relative;
            top: -45px;
            margin-left: 10px;
            font-size: 4em;
            color: #599bdc;
            font-family: Arial;
            text-shadow: 0 0 1px #999;
        }
        #logo
        {
            margin: 20px auto 15px 20px;
        }
    </style>
</head>
<body id="home">
    <div id="container">
        <div id="header">
            <a href="index.html">
                <img src="images/Icon2BlueGlow.png" alt="Logo" width="110px" height="110px" id="logo" />
            </a>
            <h1 id="head_title">
                PygmyOS</h1>
        </div>
        <div id="navbar">
            <div id="site-bar">
                <ul>
                    <li class="firstlink"><a href="index.html" id="nav-home">Home</a></li>
                    <li><a href="features.html" id="nav-code">▼ Code</a></li>
                    <li><a href="" id="nav-boards">Boards</a></li>
                    <li><a href="" id="nav-projects">Projects</a></li>
                    <li class="lastlink"><a href="contact.html" id="nav-contact">Contact</a></li>
                </ul>
            </div>
            <div id="social-bar">
                <ul>
                    <!--<li class="youtube"><a href="http://www.youtube.com/sparkfun" target="_blank" class="hidetext">
                        <span>YouTube</span></a></li>-->
                    <!--<li class="vimeo"><a href="http://www.vimeo.com/sparkfun" target="_blank" class="hidetext">
                        <span>Vimeo</span></a></li>-->
                    <li class="gplus"><a href="https://plus.google.com/106638354592939322299" class="hidetext">
                        <span>Google Plus</span></a></li>
                    <li class="facebook"><a href="http://www.facebook.com/PygmyOS" class="hidetext"><span>
                        Facebook</span></a></li>
                    <li class="flickr"><a href="http://www.flickr.com/photos/58435130@N08/sets/72157627768508212/"
                        target="_blank" class="hidetext"><span>Flickr</span></a></li>
                    <li class="twitter"><a href="https://twitter.com/#!/PygmyOS" class="hidetext"><span>
                        Twitter</span></a></li>
                    <li class="rss"><a href="http://pygmyos.wordpress.com/feed/" class="hidetext"><span>
                        RSS</span></a></li>
                </ul>
            </div>
        </div>
        <div id="carousel">
            <div class="slides">
                <div class="home_text" style="position: absolute; top: 0px; left: 0px; visibility: visible;
                    zoom: 1; z-index: 1; opacity: 1;">
                    <!--position: absolute; top: 0px; left: 0px; visibility: hidden;
                    display: none; zoom: 1; z-index: 1; opacity: 0;-->
                    <img src="images/boards/Nebula1.jpg" alt="Pygmy Nebula" />
                    <a href="index.html" class="button" style="z-index: 10; margin-top: 347px; margin-left: 25px;">
                        Learn More </a>
                </div>
            </div>
        </div>
        <div id="content" style="display:inline-block; background-color: #FFFFFF; padding: 20px 20px 20px 20px;">
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
            <h4>
                Nebula Features</h4>
            <ul>
                <li>2” round board outline</li>
                <li>STM32F100 24MHz, STM32F103 72MHz</li>
                <li>Cutting edge ARM Cortex M3</li>
                <li>Support for PygmyOS</li>
                <li>Integrated bootloader</li>
                <li>4MB Flash with filesystem</li>
                <li>2.4GHz RF</li>
                <li>LiPo battery charge and management</li>
                <li>On-board power regulation</li>
                <li>Precision temperature sensor</li>
                <li>Header with 25 general purpose IO pins
                    <ul>
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
            </ul>
        </div>
        <div id="footer" style="background-color: #f2f2ee; height: auto; border-top: 1px solid #3072b3;
            color: #93948c;">
            <p id="copyright" style="margin: 0; padding: 3px 3px 3px 3px; text-align: center;">
                PygmyOS Website Design and Copyright &copy; 2012 <a href="http://www.sparkfun.com/users/154228">
                    Evan Teitelman</a><br />
                PygmyOS Logo and Trademark Copyright &copy; 2012 Warren D Greenway</p>
        </div>
    </div>
</body>
</html>
