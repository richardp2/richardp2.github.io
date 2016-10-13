// Avoid `console` errors in browsers that lack a console.
(function() {
    var method;
    var noop = function () {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());


jQuery(document).ready(function($) {
  //$('.main-menu').slicknav({
  //  label: 'Menu',
  //  allowParentLinks: true
  //});
  
  $('.flickr').each(function(i){
    $(this).find('a.image').attr('rel','gallery'+i);
    $('.flickr a.image').colorbox({
      maxWidth:'95%', 
      maxHeight:'95%',
      scrolling: false
    });
  });

});


