$(document).ready(function() {
  if (typeof Faye !== 'undefined') {
    var faye;

    if ($('body').data('env') === 'production') {
      faye = new Faye.Client('http://mysvadba.org:9292/faye');
    } else {
      faye = new Faye.Client('http://localhost:9292/faye');
    }

    faye.subscribe('/messages/new', function (data) {
      eval(data);
    });
  }

  $(".sv-message-contact").on("click", function(){
    var message_room_id = $(this).data("message_room_id");
    var self = this;
    $.get("/message_rooms/" + message_room_id + "/read.json",
        function(message_room){
          $(self).find(".sv-message-contact__count").hide();
        }
    )
  });

  $(document).on('click', '[data-js=popup-close]', function (e) {
    e.preventDefault();
    $.fancybox.close();
  });
});
