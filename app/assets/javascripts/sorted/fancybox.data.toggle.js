$(function(){
  $('[data-toggle="modal"]').fancybox({'fitToView':false,'padding':0,'scrolling':'no','autoCenter':false,'topRatio':0});
});
!function ($) {
  $.fn.modal = function() {
    $.fancybox.open(this);
  };
}(window.jQuery);

/*
!function ($) {
  "use strict"; // jshint ;_;
  $(window).on('load', function () {
    $('[data-toggle="modal"]').each(function () {
      var $toggle = $(this)
        , data = $toggle.data()
      /*
      data.offset = data.offset || {}

      data.offsetBottom && (data.offset.bottom = data.offsetBottom)
      data.offsetTop && (data.offset.top = data.offsetTop)

      $spy.affix(data)
      * /
      $toggle.fancybox()
    })
  })
}(window.jQuery);
*/