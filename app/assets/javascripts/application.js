//= require jquery
//= require jquery_ujs

//= require select2
//= require select2_locale_ru

//= require jquery.ui.widget.js
//= require jquery-ui-1.9.1
//= require jquery.ui.noconflict
//= require rails.validations
//= require rails.validations.simple_form

//= require sorted/bootstrap

//= require jquery.iframe-transport.js

//= require jquery-fileupload
//= require jquery-minicolors
//= require jquery-minicolors-simple_form
//= require jquery.tokeninput

//= require jquery-ui-1.9.1
//= require jquery.ui.accordion

//= require main/fancybox/jquery.fancybox.pack
//= require main/fancybox/helpers/jquery.fancybox-buttons
//= require main/fancybox/helpers/jquery.fancybox-thumbs
//= require main/fancybox/helpers/jquery.fancybox-media
//= require main/jquery.mousewheel.min
//= require main/jquery.mCustomScrollbar.min
//= require main/chosen/chosen.jquery.min
//= require main/script
//= require admin/static_pages
//= require admin/background_properties
//= require admin/tags
//= require best_in_place
//= require best_in_place.purr

//= require jquery.part.migrate
//= require redactor-rails
//= require redactor-rails/plugins
//= require redactor-rails/langs/ru
//= require jquery.maskedinput
//= require jQuery.tubeplayer.min
//= require jquery.dataTables.min
//= require jquery.Jcrop.min
//= require noty/packaged/jquery.noty.packaged.js

//= require jquery.infinitescroll
//= require jquery.carouFredSel.min

//= require masonry.min
//= require jquery.menu-aim
//= require jquery-clockpicker
//= require BeatPicker.min
//= require BeatPicker-ru

//= require components/modal_viewer
//= require components/social_auth
//= require components/select2_fix
//= require jquery.combosex-0.1/jquery.combosex.min
//= require color_picker/colorpicker

//= require jquery.cookie.js
//= require autoresize.jquery.js

//= stub bootstrap
//= stub clients/site/all
//= require_tree .

function historySupport() {
    return !!(window.history && window.history.pushState !== undefined);
}

function SendBox(class_name){
  $(class_name + ' li').click(function(event){
    if($(this).hasClass('active')){
      if(event.target.nodeName != 'A'){
        $(this).removeClass('active');
      }
    }else{
      $(class_name + ' li.active').removeClass('active');
      $(this).addClass('active');
      $(this).find(".name a").trigger('click');
    }
  });
}

$(document).ready(function() {
  $(function() {
    $('body').ajaxComplete(function() {
      $('body').attr('style', 'cursor:default');
    }).bind("ajaxSend", function() {
      $('body').attr('style', 'cursor:progress');
    });
  });

  function popup(data) {
      var popup = $('#popup');
      popup.modal('hide');
      popup.find('.content').html(data);
      popup.modal('show').css({
          'margin-left': function() {
              return -($(this).width() / 2);
           }
      });
  }

  $.fn.popup = function() {
      var popup = $('#popup');
      popup.modal('hide');
      popup.find('.content').html("");
      $(this).appendTo('#popup .content');
      $(this).css('display', 'inherit');
      popup.modal('show');
  };

  $(window).scroll(function() {
    if ($(this).scrollTop() > 300) {
      $('#scroller').fadeIn();
    } else {
      $('#scroller').fadeOut();
    }
  });

  $('#up-button, #scroller-background').click(function() {
    $('body,html').animate({
      scrollTop: 0
    }, 500);
    return false;
  });

  window.searchTags();

    $('textarea.autoResize').autoResize();
    $('input.clockpicker').clockpicker({autoclose: true});
});

$('form').enableClientSideValidations();

$.extend($.fancybox.defaults, {
    beforeShow: function(){
        $('.simple_form').enableClientSideValidations();
        WeddingCitiesList.reload(['#sv-wedding-cities', '#side-city-select', '#change-first-city']);
        FirstFirmCatalogList.reload(['#change-first-firm-catalog']);
    }
});
