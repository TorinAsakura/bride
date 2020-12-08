function CommentForm(options) {
  this.MAX_WALL_UPLOADS = 6;
  this.MAX_MODAL_UPLOADS = 2;
  this.MAX_WALL_VIDEOS = 1;

  this.$elem = $(options.element);
  this.$form = this.$elem.find('[data-js=comment-form]');
  this.$formWrapper = this.$elem.find('.sv-comment-form-wrapper');
  this.$box = this.$elem.find('.sv-comments-box');
  this.modal = options.modal;
  this.multipart = options.multipart;

  this.initForm();
  this.initArrows();
  this.initReply();
}

CommentForm.prototype.initForm = function () {
  var that = this;

  if (this.multipart) {
    this.$form.on('submit', function () {
      var html,
          videoCount,
          photoCount,
          maxCount,
          data,
          videoUploader,
          photoUploader;

      videoUploader= window[that.modal ? 'modalCommentVideoUploader' : 'commentVideoUploader'];
      photoUploader = window[that.modal ? 'modalCommentPhotoUploader' : 'commentPhotoUploader'];

      videoCount = videoUploader.getUploadsCount();
      photoCount = photoUploader.getUploadsCount();
      maxCount = that.modal ? that.MAX_MODAL_UPLOADS : that.MAX_WALL_UPLOADS;

      if (videoCount + photoCount > maxCount) {
        html = $(['[data-js=comment-form', that.modal ? 'modal' : 'wall', 'warning]'].join('-')).html();
        window.auxiliaryViewer = new AuxiliaryViewer(html);
        window.auxiliaryViewer.show();

        return false;
      } else if (!that.modal && videoCount > that.MAX_WALL_VIDEOS) {
        html = $('[data-js=comment-form-video-warning]').html();
        window.auxiliaryViewer = new AuxiliaryViewer(html);
        window.auxiliaryViewer.show();

        return false;
      } else {
        that.$form.one('ajax:success', function (e, data) {
          photoUploader.send(data.images_url, function() {
            $.getScript(data.comment_url, function () {
              that.resetWindow();
              that.initReply();

              initVideoPlayer();

              photoUploader.reset();
              videoUploader.reset();

              that.$form.get(0).reset();
              that.$form.attr('action', that.$form.data('url'));
            });
          });
        });
      }
    });
  }
};

CommentForm.prototype.initArrows = function () {
  var $commentsBox = this.$elem.find('.sv-comments-box'),
      $input = this.$elem.find('[data-js=sv-comments-order]'),
      that = this;

  var toggleCurrentArrow = function() {
    that.$elem.find('.sv-comments-arrow_desc').toggleClass('sv-comments-arrow_current');
    that.$elem.find('.sv-comments-arrow_asc').toggleClass('sv-comments-arrow_current');
  };

  var revertComments = function() {
    $commentsBox.children().each(function(i, comment) {
      $commentsBox.prepend(comment);
    });
  };

  this.$elem.find('.sv-comments-arrow_asc').unbind('click').click(function(e) {
    var sortOrder = $input.val();
    if (sortOrder == 'desc') {
      revertComments();
    }
    $input.val('asc');
    toggleCurrentArrow();
    e.preventDefault();
  });

  this.$elem.find('.sv-comments-arrow_desc').unbind('click').click(function(e) {
    var sortOrder = $input.val();
    if (sortOrder == 'asc') {
      revertComments();
    }
    $input.val('desc');
    toggleCurrentArrow();
    e.preventDefault();
  });
};

CommentForm.prototype.initReply = function () {
  var $textarea = this.$elem.find('[data-js=comment-body]'),
      $link = this.$elem.find('.sv-comments-form-rlink'),
      that = this,
      padding,
      width;

  if ($textarea.length > 0 && $link.length > 0) {
    padding = parseInt($textarea.css('padding-left').replace(/[^-\d\.]/g, ''));
    width = parseInt($textarea.css('width').replace(/[^-\d\.]/g, ''));

    this.$elem.find('a.sv-comment-reply').unbind('click').click(function(e) {
      e.preventDefault();

      var $this = $(this);

      that.$elem.find('[data-js=comment-form]').attr('action', $this.data('url'));
      $link.show().html($this.data('name'));
      $textarea.css('text-indent', (padding * 2 + $link.width() + 10) + 'px');
      $textarea.attr('placeholder', '');
      $textarea.focus();
    });

    $textarea.on('keyup', function () {
      if (!$textarea.val()) {
        that.resetWindow();
        that.$form.attr('action', that.$form.data('url'));
      }
    });
  }
};

CommentForm.prototype.initStickyForm = function () {
  if (this.modal) {
    var $header,
        haveComments,
        headerPosition,
        that,
        update;

    $header = this.$elem.find('.sv-comments-header');
    if ($header.length > 0){
        that = this;
        update = function() {
            if ($('.fancybox-inner').height() > window.innerHeight) {
                haveComments = that.$elem.find('.sv-comment').length > 0;
                headerPosition = $header.offset().top + $header.outerHeight() - $(window).scrollTop() + that.$formWrapper.height();

                if (haveComments && window.innerHeight > headerPosition) {
                    that.$formWrapper.addClass('sv-comment-form-wrapper_sticky');
                    that.updatePosition(true);
                } else {
                    that.$formWrapper.removeClass('sv-comment-form-wrapper_sticky');
                    that.updatePosition(false);
                }
            }
        };

        this.updatePosition(false);
        $('.fancybox-overlay').on('scroll', update);
    }
  }
};

CommentForm.prototype.updatePosition = function (update) {
  if (this.modal) {
    $('#edit').css('padding-bottom', [update ? this.$formWrapper.height() : 0, 'px'].join(''));
  }
};

CommentForm.prototype.resetWindow = function () {
  var $textarea = this.$elem.find('[data-js=comment-body]'),
      $link = this.$elem.find('.sv-comments-form-rlink');

  $textarea.css('text-indent', '0px');
  $link.hide();
};

CommentForm.prototype.getCommentOffset = function (comment) {
  return $('.fancybox-overlay').scrollTop()
    + $('.sv-comment-form-wrapper').height()
    + comment.offset().top
    + comment.height()
    - $(window).scrollTop()
    - $(window).height();
};
