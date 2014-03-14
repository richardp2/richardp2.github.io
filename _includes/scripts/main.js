jQuery(document).ready(function($) {
  $('.main-menu').slicknav({
    label: 'Menu',
    allowParentLinks: true
  });
  
  $('.flickr').each(function(i){
    $(this).find('a.image').attr('rel','gallery'+i);
    $('.flickr a.image').colorbox({
      maxWidth:'95%', 
      maxHeight:'95%',
      scrolling: false
    });
  });

});


