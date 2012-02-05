<?php
//Loads head (EG analytics, title, document configuration, etc)
function loadHead($title)
{
?>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><?php echo "PygmyOS | " . $title ?></title>
    <link rel="Stylesheet" type="text/css" href="styles/style.css" />

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
function displayHeader($title = "PygmyOS", $icon = "images/Icon2BlueGlow.png")
{
?>
    <div id="header">
        <a href="index.php">
            <img src=<?php echo $icon ?> alt="Logo" width="90px" height="90px" id="logo" />
        </a>
        <h1 id="head_title">
        <?php echo $title ?> </h1>
    </div>
<?php
}

//Displays the page navigation bar
function displayNavbar( $links = array('index.php', 'code.php', 'boards.php', 'projects.php', 'contact.php'),
                        $linkNames = array('Home', 'Code', 'Boards', 'Projects', 'Contact'),
                        $linkPageIDs = array('nav-home', 'nav-code', 'nav-boards', 'nav-projects', 'nav-contact'))
{
?>
    <div id="navbar">
        <div id="site-bar">
            <ul>
                <?php
                if(is_array($links) && is_array($linkNames) && is_array($linkPageIDs))
                {
                    if(count($links) == count($linkNames) && count($links) == count($linkPageIDs))
                    {
                        for($i=0;$i<count($links);$i++)
                        {
                            if($i==0)
                            {
                                echo '<li class="firstlink">';
                            }
                            else if($i==count($links)-1)
                            {
                                echo '<li class="lastlink">';
                            }
                            else
                            {
                                echo '<li>';
                            }

                            echo '<a href="' . $links[$i] . '" id="' . $linkPageIDs[$i] . '">' . $linkNames[$i] . '</a></li>';
                        }
                        /*<li class="firstlink"><a href="index.html" id="nav-home">Home</a></li>
                        <li><a href="features.html" id="nav-code">▼ Code</a></li>
                        <li><a href="" id="nav-boards">Boards</a></li>
                        <li><a href="" id="nav-projects">Projects</a></li>
                        <li class="lastlink"><a href="contact.html" id="nav-contact">Contact</a></li>*/
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
                ?>
            </ul>
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
    if(is_array($pictures))
    {
        ?>
        <div id="carousel">
            <div class="slides">
                <div class="home_text" style="position: absolute; top: 0px; left: 0px; visibility: visible;
                    zoom: 1; z-index: 1; opacity: 1;">
                    <?php
                        foreach($pictures as $picture)
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