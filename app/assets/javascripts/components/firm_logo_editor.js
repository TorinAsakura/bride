function FirmLogoEditor() {
  var that = this;

  $('[data-js=firm-logo-upload]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(true);
  });

  $('[data-js=firm-logo-edit]').on('click', function(e) {
    e.preventDefault();

    that.initUploadMode(false);
    that.initEditMode();
  });
}

FirmLogoEditor.prototype.saveCoordinates = function(coordinates) {
  $("#logo_x").val(coordinates.x);
  $("#logo_y").val(coordinates.y);
  $("#logo_x2").val(coordinates.x2);
  $("#logo_y2").val(coordinates.y2);
};

FirmLogoEditor.prototype.initScale = function(src) {
  var $jcropImage, image, widthRatio, heightRatio, realWidth, readHeight;

  $jcropImage = this.initJCrop();
  realWidth = $jcropImage.width();
  readHeight = $jcropImage.height();

  image = new Image();
  image.onload = function() {
    widthRatio = this.width / realWidth;
    heightRatio = this.height / readHeight;
    $("#logo_scale").val(widthRatio > heightRatio ? widthRatio : heightRatio);
  };
  image.src = src;
};

FirmLogoEditor.prototype.destroyJCrop = function() {
  if (this.jcrop) {
    this.jcrop.destroy();

    $('[data-js=firm-logo-jcrop-image]').removeAttr('style');
  }
};

FirmLogoEditor.prototype.showEditDestroyButtons = function() {
  var menu;

  menu = $('.sv-firm-edit-logo');
  menu.find('.edit').removeClass('no-display');
  menu.find('.remove').removeClass('no-display');
};

FirmLogoEditor.prototype.initUploadMode = function(modal) {
  var $form, initModal, initForm, that;

  that = this;

  initForm = function(e, data) {
    $('[data-js=firm-logo-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    $.fancybox.update();

    $('[data-js=firm-logo-save]').off('click').on('click', function(e) {
      e.preventDefault();

      data.submit();

      $.fancybox.close();
    });
  };

  initModal = function() {
    if (modal) {
      $('[data-js=firm-logo-edit-tab]').hide();
      $('[data-js=firm-logo-upload-tab]')
        .find('a')
        .trigger('click');
    }

    $form = $('#fileupload_logo');

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
          $image = $('[data-js=firm-logo-jcrop-image]');
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
        $('[data-js=firm-logo-image]')
          .attr('src', data.jqXHR.responseJSON.logo_url+'?'+Math.floor((Math.random() * 10000)) )
          .data('image-url', data.jqXHR.responseJSON.image_url);
        that.showEditDestroyButtons();
      },
      add: initForm
    });
  };

  if (modal) {
    $.fancybox.open('#sv-firm-logo-editor', {
      'fitToView': false,
      'scrolling': 'no',
      'beforeShow': initModal
    });
  } else {
    initModal();
  }
};

FirmLogoEditor.prototype.initPreview = function(src) {
  $('.sv-firm-logo-preview-img.big').attr('src', src);
  $('.sv-firm-logo-preview-img.medium').attr('src', src);
  $('.sv-firm-logo-preview-img.small').attr('src', src);
};

FirmLogoEditor.prototype.updatePreview = function(coordinates) {
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

  previews = [[$('.sv-firm-logo-preview.big'), $('.sv-firm-logo-preview-img.big'), 5],
    [$('.sv-firm-logo-preview.medium'), $('.sv-firm-logo-preview-img.medium'), 4],
    [$('.sv-firm-logo-preview.small'), $('.sv-firm-logo-preview-img.small'), 2]];

  if (coordinates.w > 0 && coordinates.h > 0) {
    $.each(previews, function(index, args) { update.apply(null, args); });
  }
};

FirmLogoEditor.prototype.initJCrop = function() {
  var that, x1, x2, y1, y2;

  that = this;

  x1 = parseInt($("#logo_x").val());
  y1 = parseInt($("#logo_y").val());
  x2 = parseInt($("#logo_x2").val());
  y2 = parseInt($("#logo_y2").val());

  return $('[data-js=firm-logo-jcrop-image]').Jcrop({
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

FirmLogoEditor.prototype.initEditMode = function() {
  var $image, $form, that, initModal, initForm, imageUrl;

  that = this;

  initForm = function() {
    $('[data-js=firm-logo-save]').off('click').on('click', function(e) {
      e.preventDefault();

      $form = $('#fileupload_logo');
      $form.append($('<input type="hidden" name="update_logo" value="true"/>'));
      $.ajax({
        'url': $form.attr('action'),
        'type': 'post',
        'data': $form.serialize(),
        'dataType': 'json',
        'success': function(data, textStatus, jqXHR) {
          $('[data-js=firm-logo-image]')
            .attr('src', data.logo_url+'?'+Math.floor((Math.random() * 10000)))
            .data('image-url', data.image_url);
          that.showEditDestroyButtons();
        }
      });

      $.fancybox.close();
    });
  };

  initModal = function() {
    that.destroyJCrop();

    $('[data-js=firm-logo-edit-tab]')
      .show()
      .find('a')
      .trigger('click');

    imageUrl = $('[data-js=firm-logo-image]').data('image-url');

    $image = $('[data-js=firm-logo-jcrop-image]');
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

  $.fancybox.open('#sv-firm-logo-editor', {
    'fitToView': false,
    'scrolling': 'no',
    'closeBtn': false,
    'beforeShow': initModal
  });
};