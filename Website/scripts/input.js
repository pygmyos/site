// Formatting functions are from http://snipplr.com/view.php?codeview&id=13064

// Limit the text field to only numbers (with decimals)
function format(input)
{
    var num = input.value.replace(/\,/g,'');
    if(!isNaN(num))
    {
        if(num.indexOf('.') > -1)
        {
            num = num.split('.');
            num[0] = num[0].toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1,').split('').reverse().join('').replace(/^[\,]/,'');
            if(num[1].length > 2)
            {
                alert('You may only enter two decimals!');
                num[1] = num[1].substring(0,num[1].length-1);
            } input.value = num[0]+'.'+num[1];
        } 
        else
        {
            input.value = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1,').split('').reverse().join('').replace(/^[\,]/,'') };
    } 
    else
    {
        alert('You may enter only numbers in this field!');
        input.value = input.value.substring(0,input.value.length-1);
    }
}

// Limit the text field to only numbers (no decimals)
function formatInt(input)
{
    var num = input.value.replace(/\,/g,'');
    if(!isNaN(num))
    {
        if(num.indexOf('.') > -1)
        {
            alert("You may not enter any decimals.");
            input.value = input.value.substring(0,input.value.length-1);
        }
    }
    else
    {
        alert('You may enter only numbers in this field!');
        input.value = input.value.substring(0,input.value.length-1);
    }
}


/* Utilization
 * <input id="text" name="text" size="5" onkeyup="format(this);"> */