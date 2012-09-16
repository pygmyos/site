var list = [new Array, new Array, new Array, new Array, new Array]; //Stores lists and their items
var done = "<del>";



//--------START LISTS--------
//Index [x][0] holds the list name
list[0][0] = "Board";                             //List Name
list[0][1] = "Add power LED";                     //Unfinished item
//list[0][2] = "<del>Add ARM chip</del>";           //Finished item
//list[0][3] = done + "Assemble first prototypes";  //Also a finished item

list[1][0] = "Code";
list[1][1] = "Add directory support to PygmyFAT";
list[1][2] = "Upgrade enableClock with prescaler and multiplier parameters";
list[1][3] = "Add software I2C support";
list[1][4] = "Finish mesh networking code";
list[1][4] = "\n";
list[1][5] = "Servo Library";
list[1][6] = "Trig Math Functions";
list[1][7] = "Data Conversion";
list[1][8] = "Encryption";
list[1][9] = "Basic Math";

list[2][0] = "Website";
list[2][1] = "Copyright bar alignment (IE)";
list[2][2] = done + "Copyright bar text";
list[2][3] = "Page load flicker";
list[2][4] = done + "Top navigation bar hover (Chrome)";
list[2][5] = "Top navigation bar selection";
list[2][6] = "Login page";

list[3][0] = "Software";
list[3][1] = "Serial and Debug Terminal";
list[3][2] = "Map of Code";
list[3][3] = "Code Search";

list[4][0] = "Artwork";
list[4][1] = "Favicon";
list[4][2] = "Logo";
//--------END   LISTS--------



var i = 0, c = 0;
for (i = 0; i <= list.length; i++) { //Lists
    document.write("<div class=\"contentTitle\">");    //Start title
    document.write(list[i][0]);                        //Write title
    document.write("</div>");                          //End title
    document.write("<div class=\"contentText\"><p>");  //Start contents
    for (c = 1; c < list[i].length; c++) {             //Items
        document.write("<ol>");                        //Start item
        document.write(list[i][c]);                    //Write item
        document.write("</del></ol>");                 //End item and done handler
    }   
    document.write("</p></div>");                      //End contents
}

