var vkontaktePaginator = function(){
  album_id = $('.choose_photos').data('album-id');
  hide_next_link();
  $(".next").on('click', function(){
    $.get(
      '/vkontakte_media/' + album_id,
      {
        next: true,
        offset: offset() + 20
      },
      function(data){
        eval(data);
        show_prev_link();
        hide_next_link();
        increment_offset();
      },
      'script');
  });

  $(".prev").on('click', function(){
    $.get(
      '/vkontakte_media/' + album_id,
      {
        previos: true
      },
      function(data){
        eval(data)
        show_prev_link();
        hide_prev_link();
        set_default_offset();
      },
      'script');
  });
}

var show_prev_link = function(){
  $(".prev").show();
}

var hide_prev_link = function(){
  $(".prev").hide();
}
var hide_next_link = function(){
  if($('.vk_photo').length < 20){
    $('.next').hide();
  }
}

var offset = function(){
  return $.cookie('offset');
}

var set_default_offset = function(){
  $.cookie('offset', null);
}

var increment_offset = function(){
  $.cookie('offset', offset() + 20);
}
