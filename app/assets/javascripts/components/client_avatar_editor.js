function ClientAvatarEditor() {
  var that = this;

  $('[data-js=client-avatar-upload]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(true);
  });

  $('[data-js=client-avatar-edit]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(false);
    that.initEditMode();
  });
}

ClientAvatarEditor.prototype.saveCoordinates = function(coordinates) {
  $("#avatar_x").val(coordinates.x);
  $("#avatar_y").val(coordinates.y);
  $("#avatar_x2").val(coordinates.x2);
  $("#avatar_y2").val(coordinates.y2);
};

ClientAvatarEditor.prototype.initScale = function(src) {
  var $jcropImage, image, widthRatio, heightRatio, realWidth, readHeight;

  $jcropImage = this.initJCrop();
  realWidth = $jcropImage.width();
  readHeight = $jcropImage.height();

  image = new Image();
  image.onload = function() {
    widthRatio = this.width / realWidth;
    heightRatio = this.height / readHeight;
    $("#avatar_scale").val(widthRatio > heightRatio ? widthRatio : heightRatio);
  };
  image.src = src;
};

ClientAvatarEditor.prototype.destroyJCrop = function() {
  if (this.jcrop) {
    this.jcrop.destroy();

    $('[data-js=client-avatar-jcrop-image]').removeAttr('style');
  }
};

ClientAvatarEditor.prototype.showEditDestroyButtons = function() {
  $('.sv-client-avatar__action_edit').removeClass('sv-client-avatar__action_hidden');
  $('.sv-client-avatar__action_destroy').removeClass('sv-client-avatar__action_hidden');
};

ClientAvatarEditor.prototype.initUploadMode = function(modal) {
  var $form, initModal, initForm, that;

  that = this;

  initForm = function(e, data) {
    $('[data-js=client-avatar-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    $('[data-js=client-avatar-save]').off('click').on('click', function(e) {
      e.preventDefault();

      data.submit();

      $('[data-js=client-avatar-image]').attr('src', '').addClass('sv-client-avatar__image-loading');

      $.fancybox.close();
    });
  };

  initModal = function() {
    if (modal) {
      $('[data-js=client-avatar-edit-tab]').hide();
      $('[data-js=client-avatar-upload-tab]')
        .find('a')
        .trigger('click');
    }

    $form = $('#fileupload_avatar');

    try {
      $form.fileupload('destroy');
    } catch (e) {
      // we just want to prevent fileupload from throwing exception
    }

    $form.find('input[type=file]').off('change').on('change', function() {
      var $image, reader;

      that.destroyJCrop();

      if (this.files && this.files[0]) {
        reader = new FileReader();
        reader.onload = function(e) {
          $image = $('[data-js=client-avatar-jcrop-image]');
          $image.off('load').on('load', function() {
            that.initScale(e.target.result);
          });
          $image
            .css('max-width', '640px')
            .css('max-height', '640px')
            .attr('src', e.target.result);
        };
        reader.readAsDataURL(this.files[0]);
      }
    });

    $form.fileupload({
      dataType: 'json',
      uploadTemplateId: null,
      downloadTemplateId: null,
      autoUpload: false,
      done: function(e, data) {
        $('[data-js=client-avatar-image]')
          .attr('src', data.jqXHR.responseJSON.avatar_url)
          .data('image-url', data.jqXHR.responseJSON.image_url);
        that.showEditDestroyButtons();
      },
      add: initForm
    });
  };

  if (modal) {
    $.fancybox.open('#sv-client-avatar-editor', {
      'fitToView': false,
      'scrolling': 'no',
      'beforeShow': initModal
    });
  } else {
    initModal();
  }
};

ClientAvatarEditor.prototype.initJCrop = function() {
  var that, x1, x2, y1, y2;

  that = this;

  x1 = parseInt($("#avatar_x").val());
  y1 = parseInt($("#avatar_y").val());
  x2 = parseInt($("#avatar_x2").val());
  y2 = parseInt($("#avatar_y2").val());

  $.fancybox.update();

  return $('[data-js=client-avatar-jcrop-image]').Jcrop({
    onChange: that.saveCoordinates.bind(that),
    onSelect: that.saveCoordinates.bind(that),
    aspectRatio: (x2 - x1) / (y2 - y1)
  }, function() {
    var bounds = this.getBounds();

    that.boundX = bounds[0];
    that.boundY = bounds[1];

    that.jcrop = this;
  });
};

ClientAvatarEditor.prototype.initEditMode = function() {
  var $image, $form, that, initModal, initForm, imageUrl;

  that = this;

  initForm = function() {
    $('[data-js=client-avatar-save]').off('click').on('click', function(e) {
      e.preventDefault();

      $form = $('#fileupload_avatar');
      $form.append($('<input type="hidden" name="update_avatar" value="true"/>'));
      $.ajax({
        'url': $form.attr('action'),
        'type': 'post',
        'data': $form.serialize(),
        'dataType': 'json',
        'success': function(data, textStatus, jqXHR) {
          $('[data-js=client-avatar-image]')
            .attr('src', data.avatar_url)
            .data('image-url', data.image_url);
          that.showEditDestroyButtons();
        }
      });

      $('[data-js=client-avatar-image]').attr('src', '').addClass('sv-client-avatar__image-loading');

      $.fancybox.close();
    });
  };

  initModal = function() {
    that.destroyJCrop();

    $('[data-js=client-avatar-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    imageUrl = $('[data-js=client-avatar-image]').data('image-url');

    $image = $('[data-js=client-avatar-jcrop-image]');
    $image.off('load').on('load', function() {
      that.initScale(imageUrl);
    });
    $image
      .css('max-width', '640px')
      .css('max-height', '640px')
      .attr('src', imageUrl);

    initForm();
  };

  $.fancybox.open('#sv-client-avatar-editor', {
    'fitToView': false,
    'scrolling': 'no',
    'closeBtn': false,
    'beforeShow': initModal
  });
};