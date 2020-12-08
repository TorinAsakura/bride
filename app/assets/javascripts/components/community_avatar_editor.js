function CommunityAvatarEditor() {
  var that = this;

  $('[data-js=community-avatar-upload]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(true);
  });

  $('[data-js=community-avatar-edit]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(false);
    that.initEditMode();
  });
}

CommunityAvatarEditor.prototype.saveCoordinates = function(coordinates) {
  $("#avatar_x").val(coordinates.x);
  $("#avatar_y").val(coordinates.y);
  $("#avatar_x2").val(coordinates.x2);
  $("#avatar_y2").val(coordinates.y2);
};

CommunityAvatarEditor.prototype.initScale = function(src) {
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

CommunityAvatarEditor.prototype.destroyJCrop = function() {
  if (this.jcrop) {
    this.jcrop.destroy();

    $('[data-js=community-avatar-jcrop-image]').removeAttr('style');
  }
};

CommunityAvatarEditor.prototype.showEditDestroyButtons = function() {
  $('.sv-community-avatar__action_edit').removeClass('sv-community-avatar__action_hidden');
  $('.sv-community-avatar__action_destroy').removeClass('sv-community-avatar__action_hidden');
};

CommunityAvatarEditor.prototype.initUploadMode = function(modal) {
  var $form, initModal, initForm, that;

  that = this;

  initForm = function(e, data) {
    $('[data-js=community-avatar-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    $.fancybox.update();

    $('[data-js=community-avatar-save]').off('click').on('click', function(e) {
      e.preventDefault();

      data.submit();

      $.fancybox.close();
    });
  };

  initModal = function() {
    if (modal) {
      $('[data-js=community-avatar-edit-tab]').hide();
      $('[data-js=community-avatar-upload-tab]')
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
          $image = $('[data-js=community-avatar-jcrop-image]');
          $image.off('load').on('load', function() {
            that.initScale(e.target.result);
          });
          $image
            .css('max-width', '640px')
            .css('max-height', '400px')
            .attr('src', e.target.result);

          that.initPreview(e.target.result);
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
        $('[data-js=community-avatar-image]')
          .attr('src', data.jqXHR.responseJSON.avatar_url)
          .data('image-url', data.jqXHR.responseJSON.image_url);
        that.showEditDestroyButtons();
      },
      add: initForm
    });
  };

  if (modal) {
    $.fancybox.open('#sv-community-avatar-editor', {
      'fitToView': false,
      'scrolling': 'no',
      'beforeShow': initModal
    });
  } else {
    initModal();
  }
};

CommunityAvatarEditor.prototype.initPreview = function(src) {
  $('.sv-community-avatar-preview-img.big').attr('src', src);
  $('.sv-community-avatar-preview-img.medium').attr('src', src);
  $('.sv-community-avatar-preview-img.small').attr('src', src);
};

CommunityAvatarEditor.prototype.updatePreview = function(coordinates) {
  var that, update, previews;

  this.saveCoordinates(coordinates);

  that = this;

  update = function(wrapper, preview, border) {
    var rx, ry;

    rx = (wrapper.width() - border * 2) / coordinates.w;
    ry = (wrapper.height() - border * 2) / coordinates.h;
    preview.css({
      width: Math.round(rx * that.boundX) + "px",
      height: Math.round(ry * that.boundY) + "px",
      marginLeft: "-" + Math.round(rx * coordinates.x) + "px",
      marginTop: "-" + Math.round(ry * coordinates.y) + "px"
    });
  };

  previews = [[$('.sv-community-avatar-preview.big'), $('.sv-community-avatar-preview-img.big'), 0],
    [$('.sv-community-avatar-preview.medium'), $('.sv-community-avatar-preview-img.medium'), 0],
    [$('.sv-community-avatar-preview.small'), $('.sv-community-avatar-preview-img.small'), 0]];

  if (coordinates.w > 0 && coordinates.h > 0) {
    $.each(previews, function(index, args) { update.apply(null, args); });
  }
};

CommunityAvatarEditor.prototype.initJCrop = function() {
  var that, x1, x2, y1, y2;

  that = this;

  x1 = parseInt($("#avatar_x").val());
  y1 = parseInt($("#avatar_y").val());
  x2 = parseInt($("#avatar_x2").val());
  y2 = parseInt($("#avatar_y2").val());

  return $('[data-js=community-avatar-jcrop-image]').Jcrop({
    onChange: that.updatePreview.bind(that),
    onSelect: that.updatePreview.bind(that),
    aspectRatio: (x2 - x1) / (y2 - y1)
  }, function() {
    var bounds = this.getBounds();

    that.boundX = bounds[0];
    that.boundY = bounds[1];

    that.jcrop = this;
  });
};

CommunityAvatarEditor.prototype.initEditMode = function() {
  var $image, $form, that, initModal, initForm, imageUrl;

  that = this;

  initForm = function() {
    $('[data-js=community-avatar-save]').off('click').on('click', function(e) {
      e.preventDefault();

      $form = $('#fileupload_avatar');
      $form.append($('<input type="hidden" name="update_avatar" value="true"/>'));
      $.ajax({
        'url': $form.attr('action'),
        'type': 'post',
        'data': $form.serialize(),
        'dataType': 'json',
        'success': function(data, textStatus, jqXHR) {
          $('[data-js=community-avatar-image]')
            .attr('src', data.avatar_url)
            .data('image-url', data.image_url);
          that.showEditDestroyButtons();
        }
      });

      $.fancybox.close();
    });
  };

  initModal = function() {
    that.destroyJCrop();

    $('[data-js=community-avatar-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    imageUrl = $('[data-js=community-avatar-image]').data('image-url');

    $image = $('[data-js=community-avatar-jcrop-image]');
    $image.off('load').on('load', function() {
      that.initScale(imageUrl);
    });
    $image
      .css('max-width', '640px')
      .css('max-height', '400px')
      .attr('src', imageUrl);

    that.initPreview(imageUrl);

    initForm();
  };

  $.fancybox.open('#sv-community-avatar-editor', {
    'fitToView': false,
    'scrolling': 'no',
    'closeBtn': false,
    'beforeShow': initModal
  });
};
