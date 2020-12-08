function FirmBannerEditor() {
  this.initUploader();
  this.initEditLink();
}

FirmBannerEditor.prototype.saveCoordinates = function(coordinates) {
  $("#banner_x").val(coordinates.x);
  $("#banner_y").val(coordinates.y);
  $("#banner_x2").val(coordinates.x2);
  $("#banner_y2").val(coordinates.y2);
};

FirmBannerEditor.prototype.saveParams = function() {
  $('[data-js=banner-title-hidden]').val($('[data-js=banner-title-input]').val());
  $('[data-js=banner-link-hidden]').val($('[data-js=banner-link-input]').val());
  $('[data-js=banner-description-hidden]').val($('[data-js=banner-description-input]').val());
};

FirmBannerEditor.prototype.initJCrop = function() {
  var $image, that, x1, x2, y1, y2, w, h, leftTop, rightBottom;

  that = this;

  $image = $('.sv-firm-banner-jcrop img:first');
  w = $image.width();
  h = $image.height();
  x1 = parseInt($("#banner_x").val());
  y1 = parseInt($("#banner_y").val());
  x2 = parseInt($("#banner_x2").val());
  y2 = parseInt($("#banner_y2").val());
  leftTop = { 'x': (w - x2 + x1) / 2, 'y': (h - y2 + y1) / 2 };
  rightBottom = { 'x': leftTop.x + x2 - x1, 'y': leftTop.y + y2 - y1 };

  if (this.jcrop) {
    this.jcrop.destroy();
  }

  $image.Jcrop({
    onChange: that.saveCoordinates,
    onSelect: that.saveCoordinates,
    aspectRatio: (x2 - x1) / (y2 - y1),
    setSelect: [leftTop.x, leftTop.y, rightBottom.x, rightBottom.y]
  }, function() {
    that.jcrop = this;
  });
};

FirmBannerEditor.prototype.initScale = function(src) {
  var image;

  this.initJCrop();

  image = new Image();
  image.onload = function() {
    $('#banner_scale').val(this.width / $('.sv-firm-banner-jcrop').width());
  };
  image.src = src;
};

FirmBannerEditor.prototype.initUploader = function() {
  var $form, that, initForm;

  that = this;

  initForm = function(e, data) {
    $('.sv-firm-banner-editor-save').unbind('click').on('click', function(e) {
      e.preventDefault();

      that.saveParams();
      data.submit();

      $.fancybox.close();
    })
  };

  $form = $('#fileupload_banner');
  $form.fileupload({
    dataType: 'json',
    uploadTemplateId: null,
    downloadTemplateId: null,
    autoUpload: false,
    done: function() { window.location.reload(); },
    add: initForm
  });
  $form.find('input[type=file]').change(function() {
    var $image, reader;

    if (this.files && this.files[0]) {
      reader = new FileReader();
      reader.onload = function(e) {
        $image = $('.sv-firm-banner-jcrop img:first');
        $image.load(function() {
          $.fancybox.open($('#sv-firm-banner-editor'), {
            fitToView: false,
            scrolling: 'no',
            closeBtn: false,
            afterShow: function() { that.initScale(e.target.result); }
          });
        });
        $image.attr('src', e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    }
  });
};

FirmBannerEditor.prototype.initEditLink = function() {
  var $image, $banner, $form, that, initForm;

  that = this;

  initForm = function(id) {
    $('.sv-firm-banner-editor-save').unbind('click').on('click', function(e) {
      e.preventDefault();

      that.saveParams();
      $form = $('#fileupload_banner');
      $form.append($('<input type="hidden" name="album[pictures][][id]" value="' + id + '"/>'));
      $.post(
        $form.attr('action'),
        $form.serialize(),
        function() { window.location.reload(); },
        'json'
      );

      $.fancybox.close();
    });
  };

  $('[data-js=firm-banner-edit-link]').unbind('click').on('click', function(e) {
    e.preventDefault();

    $banner = $('.sv-firm-carousel .poster-item:first');
    $('[data-js=banner-title-input]').val($banner.data('title'));
    $('[data-js=banner-link-input]').val($banner.data('link'));
    $('[data-js=banner-description-input]').val($banner.data('description'));

    $image = $('.sv-firm-banner-jcrop img:first');
    $image.load(function() {
      $.fancybox.open($('#sv-firm-banner-editor'), {
        fitToView: false,
        scrolling: 'no',
        closeBtn: false,
        afterShow: function() { that.initScale($image.attr('src')); }
      })
    });
    $image.attr('src', $(this).data('image-link'));

    initForm($banner.data('id'));
  });
};