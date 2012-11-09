// $Id: jskitcomments.js,v 1.4 2010/01/06 10:12:28 rehos Exp $

/**
* JS-Kit Comment count filter
* @param count
* @return The text for number of comments with correct plural format
*/
function JSKitCommentsCountFilter(count) {
    return Drupal.formatPlural(count, "1 Comment", "@count Comments");
}

/**
* Drupal JS-Kit behaviors.
*/
Drupal.behaviors.jskitcomments = function (context) {
    if (Drupal.settings.jskitcomments) {
        // This prevents JS-Kit from using document.write().
        window.$JCCAI = true;

        // Process through all desired JS-Kit APIs.
        jQuery.each(Drupal.settings.jskitcomments, function (index, value) {
            // Make the AJAX call for the JS-Kit API using the browser cache.
            var ajaxOptions = {
                type: 'GET',
                url: window.location.protocol + '//js-kit.com/' + value + '.js',
                dataType: 'script',
                cache: true
            }
            if (value == 'comments' && Drupal.settings.jskitcommentscss) {
                ajaxOptions.success = function (data, status) {
                    JSKitAPI.subscribe('comments-data-loaded', function () {
                        $('head').append('<link rel="stylesheet" type="text/css" href="' + Drupal.settings.jskitcommentscss + '"/>');
                    });
                }
            }

            var epburl = typeof (Drupal.settings.jskitcommentsEPBurl) !== 'undefined' ? Drupal.settings.jskitcommentsEPBurl.toString() : '';

            if (value == 'comments' && epburl != '') {
                //get EPB and then load comments
                var epbAjaxOptions = {
                    type: 'GET',
                    url: epburl,
                    dataType: 'json',
                    cache: true,
                    success: function (data, status) {
                        window.JSK$EPB = data;
                        jQuery.ajax(ajaxOptions);
                    }
                }
                jQuery.ajax(epbAjaxOptions);
            } else {
                jQuery.ajax(ajaxOptions);
            }
        });

        // Make sure it doesn't process the elements twice.
        Drupal.settings.jskitcomments = false;
    }
};
