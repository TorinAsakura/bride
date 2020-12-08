function VideoPreview(video) {
  this.$video = $(video);
  try {
    this.initYouTubeVideo();
  } catch(e) {
    this.$video.css('background', '#ccc');
  }
}

VideoPreview.prototype.initYouTubeVideo = function() {
    var youtubeUrl = this.$video.find('.video').data('youtube'),
        videoId,
        apiUrl,
        imgUrl,
        link,
        title,
        dataDuration,
        duration;

    if (youtubeUrl) {
        videoId = youtubeUrl.match(/(?:&|\?)v=([-|\w^&]+)/);
        apiUrl = 'http://gdata.youtube.com/feeds/api/videos/' + videoId[1] + '?v=2&alt=jsonc';

        if (videoId && videoId[1]) {
            imgUrl = 'http://i2.ytimg.com/vi/' + videoId[1] + '/mqdefault.jpg';
            link = this.$video.find('.video');

            $.get(apiUrl, function(data) {
                title = link.data('title');
                if (data.data != undefined) {
                    dataDuration = data.data.duration
                } else {
                    console.log(videoId);
                    console.log(data);
                }

                duration = secondsToTime(dataDuration);
                link.append($('<img src="' + imgUrl + '"/>'));
                link.append($('<span class="clear"><b>' + title + '</b><i>' + duration + '</i></span>'));

                link.click(function() {

                });
            });
        }
    }
};
