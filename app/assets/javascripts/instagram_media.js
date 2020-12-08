var instagramPaginator = function(){
  $(".next").on('click', function(){
    $.get(
      '/instagram_media',
      {
        next: true,
        max_id: $(".next").data('last-image-id')
      },
      function(data){
        eval(data);
        show_prev_link();
        hide_next_link();
      },
      'script');
  });

  $(".prev").on('click', function(){
    $.get(
      '/instagram_media',
      {
        previos: true,
        last_image: $(".next").data('last-image-id'),
        first_image: $('.prev').data('first-image-id')
      },
      function(data){
        eval(data)
        show_prev_link();
        hide_prev_link();
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
  if($('.instagram_photo').length < 20){
    $('.next').hide();
  }
}
