function secondsToTime(secs) {
  var hours = Math.floor(secs / (60 * 60));

  var divisor_for_minutes = secs % (60 * 60);
  var minutes = Math.floor(divisor_for_minutes / 60);

  var divisor_for_seconds = divisor_for_minutes % 60;
  var seconds = Math.ceil(divisor_for_seconds);

  if (hours   < 10) {hours   = "0" + hours;}
  if (minutes < 10) {minutes = "0" + minutes;}
  if (seconds < 10) {seconds = "0" + seconds;}
  return hours + ":" + minutes + ":" + seconds;
}

function initVideoPreviews() {
  $('.sv-video-list-block').each(function() {
    new VideoPreview(this);
  });
}

function initVideoPlayer() {
  $('[data-js=video-player]').each(function() {
    var $this = $(this),
      youtubeUrl = $this.data('youtube'),
      videoId;

    if (youtubeUrl) {
      videoId = youtubeUrl.match(/(?:&|\?)v=([^&]+)/);

      if (videoId && videoId.length > 0) {
        $this.tubeplayer({
          width: $this.data('width') || 640,
          height: $this.data('height') || 350,
          allowFullScreen: 'true',
          initialVideo: videoId[1],
          preferredQuality: 'default'
        });
      }
    }
  });
}

var hoveredVideoPreview = function(){
  $(".video_link_preview").hover(function(){
    $(this).find(".video-info").css("background", "black");
  });

  $(".video_link_preview").focusout(function(){
    console.log("focus out");
    //$(this).find(".video-info").css("background", "image-url('sorted/sv-bg-trans-gray.png') repeat scroll 0 0 transparent;");
  })
}

$(document).ready(function() {
  new VideoSearchForm();

  initVideoPreviews();
  initVideoPlayer();

  $('[data-js=video-list]').infinitescroll({
    navSelector: '.sv-videos-hidden-nav',
    nextSelector: '.sv-videos-hidden-nav link[rel=next]',
    itemSelector: '[data-js=video]',
    appendCallback: true
  }, function () {
    initVideoPreviews();
  });  
});

