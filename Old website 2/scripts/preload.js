if (document.images) {
    preload_image_object = new Image();
    // set image url
    image_url = new Array(); //Image list
    image_url[0] = "images/pics/Main1.jpg";
    image_url[1] = "images/pics/Main2.jpg";
    image_url[2] = "images/pics/Main3.jpg";
    image_url[3] = "images/pics/Main4.jpg";
    image_url[4] = "images/pics/Main1Mini.jpg";
    image_url[5] = "images/pics/Main2Mini.jpg";
    image_url[6] = "images/pics/Main3Mini.jpg";
    image_url[7] = "images/pics/Main4Mini.jpg";

    var i = 0;
    for (i = 0; i <= 7; i++) //Preload the list
        preload_image_object.src = image_url[i];
}