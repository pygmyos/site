<?php
    /* Page components */

    //Loads head (EG analytics, title, document configuration, etc)
    function loadHead($title)
    {
        ?>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><?php echo "PygmyOS | " . $title ?></title>
        <link rel="Stylesheet" type="text/css" href="styles/site.css" />
        <link rel="Stylesheet" type="text/css" href="styles/buttons.css" />
        <link rel="Stylesheet" type="text/css" href="styles/carousel.css" />

        <!-- Google analytics -->
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-24284578-3']);
            _gaq.push(['_trackPageview']);

            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
        <?php
    }

    //Displays the page header
    function displayHeader($title = "PygmyOS", $icon = "images/Icon2BlueLight.png")
    {
        ?>
        <div id="header">
            <a href="index.php">
                <img src=<?php echo $icon ?> alt="Logo" width="90px" height="90px" id="logo" />
            </a>
            <div id="header_text">
                <h1 id="header_title">
                    <?php echo $title ?>
                </h1>
                <h5 id="header_subtitle">
                    An STM32&trade; based operating system
                </h5>
            </div>
        </div>
        <?php
    }

    //Displays the page navigation bar
    function displayNavbar($links = array('index.php', 'code.php', 'boards.php', 'projects.php', 'contact.php'), $linkNames = array('Home', 'Code', 'Boards', 'Projects', 'Contact'), $linkPageIDs = array('nav-home', 'nav-code', 'nav-boards', 'nav-projects', 'nav-contact'))
    {
        ?>
        <div id="navbar">
            <div id="site-bar">
                <?php
                echo "<ul>\n";
                if (is_array($links) && is_array($linkNames) && is_array($linkPageIDs))
                {
                    if (count($links) == count($linkNames) && count($links) == count($linkPageIDs))
                    {
                        for ($i = 0; $i < count($links); $i++)
                        {
                            if ($i == 0)
                            {
                                echo "<li class='firstlink'>\n";
                            }
                            else if ($i == count($links) - 1)
                            {
                                echo "<li class='lastlink'>\n";
                            }
                            else
                            {
                                echo "<li>\n";
                            }

                            echo "<a href='$links[$i]' id='$linkPageIDs[$i]'>$linkNames[$i]</a></li>\n";
                        }
                    }
                    else
                    {
                        throw new Exception('Links, link names, and link page IDs must be passed in equal numbers');
                    }
                }
                else
                {
                    throw new Exception('Links must be passed to navbar as arrays.');
                }
                echo "</ul>\n";
                ?>
            </div>
            <div id="social-bar">
                <ul>
                    <!--<li class="youtube"><a href="http://www.youtube.com/sparkfun" target="_blank" class="hidetext">
                        <span>YouTube</span></a></li>-->
                    <!--<li class="vimeo"><a href="http://www.vimeo.com/sparkfun" target="_blank" class="hidetext">
                        <span>Vimeo</span></a></li>-->
                    <li class="gplus"><a href="https://plus.google.com/106638354592939322299" class="hidetext" target="_blank">
                            <span>Google Plus</span></a></li>
                    <li class="facebook"><a href="http://www.facebook.com/PygmyOS" class="hidetext" target="_blank"><span>
                                Facebook</span></a></li>
                    <li class="flickr"><a href="http://www.flickr.com/photos/58435130@N08/sets/72157627768508212/"
                                          target="_blank" class="hidetext" target="_blank"><span>Flickr</span></a></li>
                    <li class="twitter"><a href="https://twitter.com/#!/PygmyOS" class="hidetext" target="_blank"><span>
                                Twitter</span></a></li>
                    <li class="rss"><a href="http://pygmyos.wordpress.com/feed/" class="hidetext" target="_blank"><span>
                                RSS</span></a></li>
                    <!--<li class="icon"><a href="index.html"></a></li>-->
                </ul>
            </div>
        </div>
        <?php
    }

//Displays the picture carousel
    function displayCarousel($pictures)
    {
        if (is_array($pictures))
        {
            ?>
            <div id="carousel">
                <div class="slides">
                    <div class="home_text" style="position: absolute; top: 0px; left: 0px; visibility: visible;
                         zoom: 1; z-index: 1; opacity: 1;">
                         <?php
                         foreach ($pictures as $picture)
                         {
                             echo '<img src="' . $picture . '" alt="Pygmy pictures" />';
                         }
                         ?>
                    </div>
                </div>
            </div>
            <?php
        }
        else
        {
            throw new Exception('Pictures must be passed to the carousel as an array.');
        }
    }

    //Displays the footer
    function displayFooter()
    {
        ?>
        <div id="footer">
            PygmyOS Website Design and Copyright &copy; 2012 <a href="http://www.sparkfun.com/users/154228">
                Evan Teitelman</a> | <a href="http://code.google.com/p/pygmyos/source/browse/?repo=site#git%2FWebsite" target="_blank">Site source</a><br />
            PygmyOS Logo and Trademark Copyright &copy; 2012 Warren D Greenway
        </div>
        <?php
    }
?>

<?php
/* Utility functions */

//Checks string to see if it contains a substring
//Based on: http://www.thetechrepo.com/main-articles/451-php-check-if-a-string-contains-a-substring
    function strContains($string, $substring)
    {
        $pos = strpos($string, $substring);

        if ($pos === false)
        {
            //String not found
            return false;
        }
        else
        {
            //String found
            return true;
        }
    }

    //Extracts enum items from SQL column_type
    function getSqlEnumItems($column_type)
    {
        //Turns the enum column_type into an array declaration
        $arrayDeclaration = str_replace('enum', 'array', $column_type);
        //Uses the array declaration to form an array containing the enum items
        $arbitraryTransfer = "\$items = $arrayDeclaration;";

        //Security measure: checks to make sure only one semicolon is passed to the eval statement
        if (substr_count($arbitraryTransfer, ";") == 1)
        {
            //Runs the transfer code
            eval($arbitraryTransfer);
        }
        return $items;
    }
?>