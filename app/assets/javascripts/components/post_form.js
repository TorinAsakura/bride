function PostForm(html) {
  this.html = html;

  this.$wrapper = $('#edit');

  this.fancyboxOptions = {
    'fitToView': false,
    'scrolling': 'no',
    'onUpdate': function () {
      $('.fancybox-wrap').css('top', '50px');
    },
    'afterClose': function () {
      window.auxiliaryViewer = new AuxiliaryViewer($('[data-js=post-form-warning]').html());
      window.auxiliaryViewer.show();
    }
  };

  $(document).on('click', '[data-js=post-form-warning-ok]', function (e) {
    e.preventDefault();

    window.auxiliaryViewer.allowClose = true;
    $.fancybox.close();
  });

  $(document).on('click', '[data-js=post-form-warning-cancel]', function (e) {
    e.preventDefault();

    $.fancybox.close();
  });
}

PostForm.prototype.show = function () {
  var that = this;

  this.$wrapper.html(this.html);
  this.$form = $('[data-js=post-form]');
  this.$file = this.$form.find('[data-js=post-form-file]');

  $.fancybox.open(this.$wrapper, $.extend({}, this.fancyboxOptions, {
    'beforeShow': function () {
      that.initButtons();
      that.initForm();
      that.initTags();

      window.postIllustrationEditor = new PostIllustrationEditor();

      window.searchTags();
    }
  }));
};

PostForm.prototype.resume = function () {
  $.fancybox.open(this.$wrapper, this.fancyboxOptions);
};

PostForm.prototype.initButtons = function () {
  var that = this;

  $('.sv-post-upload-poster').on('click', function (e) {
    e.preventDefault();

    that.$file.trigger('click');
  });

  $('[data-js=post-form-submit]').on('click', function (e) {
    e.preventDefault();

    that.$form.submit();
  });
};

PostForm.prototype.initForm = function () {
  var that = this;

  this.$form.on('submit', function () {
    if (that.$wrapper.find('[data-js=post-title-field]').val().length &&
        that.$wrapper.find('[data-js=post-body-field]').val().length > 5) {
      $('.sv-post-form-loading').removeClass('sv-post-form-loading_hidden');

      that.$form.ajaxSubmit({
        'dataType': 'json',
        'success': function (response, status, xhr) {
          that.$form.find('input[name=_method]').remove();
          window.postPhotoUploader.send(xhr.responseJSON.images_url, function () {
            window.location.href = xhr.responseJSON.post_url;
          });
        }
      });
    }

    return false;
  });
};

PostForm.prototype.initTags = function () {
  $('input#token-input-post_tag_list')
    .attr('placeholder', 'Введите теги через tab')
    .on('focus', function () {
      $(this).removeAttr('placeholder')
    });
};