//Top Navigation Bar
function topNavigationBar() {
    document.write("<div id=\"page\">");
    document.write("    <div class=\"topNaviagationLink\">");
    document.write("        <a href=\"index\">Home</a></div>");
    document.write("    <div class=\"topNaviagationLink\">");
    document.write("        <a href=\"features\">Features</a></div>");
    document.write("    <div class=\"topNaviagationLink\">");
    document.write("        <a href=\"downloads\">Downloads</a></div>");
    document.write("    <div class=\"topNaviagationLink\">");
    document.write("        <a href=\"contact\">Contact Us</a></div>");
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
//Gallery Embeded
function embedGallery() {
    window.addEvent('domready', startGallery);
}
//Gallery Contents
function structureGallery() {
    document.write("<div id=\"galleryFrame\">");
    document.write("    <div class=\"content\">");
    document.write("        <div id=\"myGallery\">");
    document.write("            <div class=\"imageElement\">");
    document.write("                <h3>");
    document.write("                    Web Board</h3>");
    document.write("                <p>");
    document.write("                    Photo View (Blue)</p>");
    document.write("                <a href=\"#\" title=\"open image\" class=\"open\"></a>");
    document.write("                <img alt=\"Web Board\" src=\"images/pics/Main1.jpg\" class=\"full\" />");
    document.write("                <img src=\"images/pics/Main1Mini.jpg\" class=\"thumbnail\" alt=\"Web Board\" />");
    document.write("            </div>");
    document.write("            <div class=\"imageElement\">");
    document.write("                <h3>");
    document.write("                    Web Board</h3>");
    document.write("                <p>");
    document.write("                    Photo View (Normal)</p>");
    document.write("                <a href=\"#\" title=\"open image\" class=\"open\"></a>");
    document.write("                <img src=\"images/pics/Main2.jpg\" class=\"full\" alt=\"Web Board\" />");
    document.write("                <img src=\"images/pics/Main2Mini.jpg\" class=\"thumbnail\" alt=\"Web Board\" />");
    document.write("            </div>");
    document.write("            <div class=\"imageElement\">");
    document.write("                <h3>");
    document.write("                    Web Board</h3>");
    document.write("                <p>");
    document.write("                    Front View</p>");
    document.write("                <a href=\"#\" title=\"open image\" class=\"open\"></a>");
    document.write("                <img src=\"images/pics/Main3.jpg\" class=\"full\" alt=\"Web Board\" />");
    document.write("                <img src=\"images/pics/Main3Mini.jpg\" class=\"thumbnail\" alt=\"Web Board\" />");
    document.write("            </div>");
    document.write("            <div class=\"imageElement\">");
    document.write("                <h3>");
    document.write("                    Web Board</h3>");
    document.write("                <p>");
    document.write("                    Back View</p>");
    document.write("                <a href=\"#\" title=\"open image\" class=\"open\"></a>");
    document.write("                <img src=\"images/pics/Main4.jpg\" class=\"full\" alt=\"Web Board\" />");
    document.write("                <img src=\"images/pics/Main4Mini.jpg\" class=\"thumbnail\" alt=\"Web Board\" />");
    document.write("            </div>");
    document.write("        </div>");
    document.write("    </div>");
    document.write("</div>");
}

function footer() {
    document.write("<div id=\"footer\">");
    document.write("<a href=\"http://www.pygmy-os.com\">PygmyOS</a>, Copyright 2011 Warren D Greenway");
    document.write("PygmyOS Website Design and Copyright <a href=\"http://paradoxial.wordpress.com\">Evan");
    document.write("    Teitelman</a>");
    document.write("</div>");
}