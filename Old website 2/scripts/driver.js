//Google Analytics
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-24284578-1']);
_gaq.push(['_trackPageview']);

(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

//Links
var links = [new Array, new Array, new Array, new Array];
links[0][0] = "Home";  //Name
links[0][1] = "index"; //Location (In relevence to root of site)

links[1][0] = "Features";
links[1][1] = "features";

links[2][0] = "Downloads";
links[2][1] = "files/packages";

links[3][0] = "Contact Us";
links[3][1] = "contact";

//Pictures
var pictures = [new Array, new Array, new Array, new Array];
pictures[0][0] = "Web Board";                  //Title
pictures[0][1] = "Photo View (Blue)";          //Description
pictures[0][2] = "Web Board";                  //Alt 
pictures[0][3] = "images/pics/Main1.jpg";      //Picture (In relevence to root of site)
pictures[0][4] = "images/pics/Main1Mini.jpg";  //Thumbnail

pictures[1][0] = "Web Board";
pictures[1][1] = "Photo View (Normal)";
pictures[1][2] = "Web Board";
pictures[1][3] = "images/pics/Main2.jpg";
pictures[1][4] = "images/pics/Main2Mini.jpg";

pictures[2][0] = "Web Board";
pictures[2][1] = "Front View";
pictures[2][2] = "Web Board";
pictures[2][3] = "images/pics/Main3.jpg";
pictures[2][4] = "images/pics/Main3Mini.jpg";

pictures[3][0] = "Web Board";
pictures[3][1] = "Back View";
pictures[3][2] = "Web Board";
pictures[3][3] = "images/pics/Main4.jpg";
pictures[3][4] = "images/pics/Main4Mini.jpg";

var footerContents = [
"<div id=\"footer\">",
"    <a href=\"http://www.pygmy-os.com\">PygmyOs</a> Website Design and Copyright &copy; 2011",
"    Evan Teitelman &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PygmyOs Logo and Trademark Copyright",
"    &copy; 2011 Warren D Greenway",
"</div>"
];

//Top Navigation Bar
function topNavigationBar(prefix) {
    document.write("<div id=\"page\">");
    for (i = 0; i < links.length; i++) {
        document.write("<div class=\"topNaviagationLink\">");       //Start Link
        document.write("<a href=\"" + prefix + links[i][1] + "\">" + links[i][0] + "</a></div>"); //Link and Text
    }
    document.write("</div>");
}

//Gallery Settings
function startGallery() {
    var myGallery = new gallery($('myGallery'), {
        timed: false,
        showArrows: false,
        showCarousel: true,
        showInfopane: false,
        embedLinks: false
    });
}

//Gallery Embed
function embedGallery(prefix) {
    window.addEvent('domready', startGallery);

    document.write("<div id=\"galleryFrame\">");    //Picture Frame
    document.write("<div class=\"content\">");
    document.write("<div id=\"myGallery\">");

    for (i = 0; i < pictures.length; i++) {
        document.write("<div class=\"imageElement\">");                             //Start
        document.write("<h3>" + pictures[i][0] + "</h3>");                              //Title
        document.write("<p>" + pictures[i][1] + "</p>");                                //Description
        document.write("<a href=\"#\" title=\"open image\" class=\"open\"></a>");   //Embed Link
        document.write("<img src=\"" + prefix + pictures[i][3] + "\" class=\"full\" alt=\"" + pictures[i][2] + "\" />");             //Main Picture
        document.write("<img src=\"" + prefix + pictures[i][4] + "\" class=\"thumbnail\" alt=\"" + pictures[i][2] + "\" /></div>");  //Thumbnail and end
    }

    document.write("</div></div></div>"); //End Frame
}

function footer() {
    for (i = 0; i < footerContents.length; i++) {
        document.write(footerContents[i]);
    }
}