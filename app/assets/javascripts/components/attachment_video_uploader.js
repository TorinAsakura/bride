function AttachmentVideoUploader(options) {
  this.$wrapper         = $(options.wrapper || document);
  this.$popover         = this.$wrapper.find(options.popover);
  this.popoverInput     = options.popoverInput;
  this.videoForm        = options.videoForm;
  this.videoInput       = options.videoInput;
  this.$button          = this.$wrapper.find(options.button);
  this.$template        = this.$wrapper.find(options.template);
  this.templateClass    = options.templateClass;
  this.$videos          = this.$wrapper.find(options.videos);
  this.videosEmptyClass = options.videosEmptyClass;
  this.video            = options.video;

  this.videosCounter = 0;

  this.initButton();
  this.initUploader();
  this.initDestroyLinks();
}

AttachmentVideoUploader.prototype.initButton = function () {
  this.$button.popover({
    'html': true,
    'title': 'Введите ссылку с YouTube',
    'placement': 'left',
    'content': this.$popover.html()
  });
};

AttachmentVideoUploader.prototype.initUploader = function () {
  var that = this;

  this.$button.on('click', function (e) {
    e.preventDefault();

    $(that.videoForm).on('submit', function (e) {
      var url, video;

      e.preventDefault();

      that.videosCounter += 1;
      that.$button.trigger('click');
      url = $(this).find(that.popoverInput).val();

      video = that.$template.clone();
      video.find(that.videoInput).val(url);
      video
        .removeClass(that.templateClass)
        .attr('data-youtube', url)
        .appendTo(that.$videos);

      that.$videos.removeClass(that.videosEmptyClass);

      initVideoPlayer();

      that.$videos.find('remove').on('click', function (e) {
        e.preventDefault();

        $(this).parent('div').remove();
      });

      if (window.commentForm) {
        window.commentForm.updatePosition(true);
      }
    });
  });
};

AttachmentVideoUploader.prototype.initDestroyLinks = function () {
  $('.video .destroy_link').on('click', function (e) {
    e.preventDefault();

    $(this).parent().remove();
  });
};

AttachmentVideoUploader.prototype.reset = function () {
  this.videosCounter = 0;
  this.$videos.find(this.video).remove();
};

AttachmentVideoUploader.prototype.getUploadsCount = function () {
  return this.videosCounter;
};