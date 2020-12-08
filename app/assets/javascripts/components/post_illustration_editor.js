function PostIllustrationEditor() {
  this.initModal();
}

PostIllustrationEditor.prototype.initModal = function () {
  var $image = $('[data-js=post-illustration-jcrop-image]'),
      reader,
      showModal,
      that = this;

  $('[data-js=post-form-file]').off('change').on('change', function () {
    that.destroyJCrop();

    if (this.files && this.files[0]) {
      reader = new FileReader();
      reader.onload = function (e) {
        showModal = function () {
          $.fancybox.open($('#illustration-popup'), {
            'fitToView': false,
            'scrolling': 'no',
            'closeBtn': false,
            'helpers' : {
              'overlay' : {
                'closeClick': false
              }
            },
            'afterShow': function () {
              that.initScale(e.target.result);
              that.initPreview(e.target.result);

              $('[data-js=post-illustration-image]')
                .css('max-width', '1000px')
                .css('width', $image.width());
            }
          });
        };

        $image.off('load').on('load', function() {
          showModal();
        });
        $image.attr('src', e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    }
  });

  $('[data-js=post-illustration-close]').on('click', function (e) {
    e.preventDefault();

    window.postForm.resume();
  });
};

PostIllustrationEditor.prototype.initJCrop = function () {
  var that, x1, y1, x2, y2, w, h, leftTop, rightBottom, $image;

  that = this;

  $image = $('[data-js=post-illustration-jcrop-image]');

  x1 = parseInt($("#illustration_x").val());
  y1 = parseInt($("#illustration_y").val());
  x2 = parseInt($("#illustration_x2").val());
  y2 = parseInt($("#illustration_y2").val());

  w = $image.width();
  h = $image.height();
  leftTop = {
    'x': (w - x2 + x1) / 2,
    'y': (h - y2 + y1) / 2
  };
  rightBottom = {
    'x': leftTop.x + x2 - x1,
    'y': leftTop.y + y2 - y1
  };

  return $image.Jcrop({
    'onChange': that.updatePreview.bind(that),
    'onSelect': that.updatePreview.bind(that),
    'aspectRatio': (x2 - x1) / (y2 - y1),
    'setSelect': [leftTop.x, leftTop.y, rightBottom.x, rightBottom.y]
  }, function () {
    var bounds = this.getBounds();

    that.boundX = bounds[0];
    that.boundY = bounds[1];

    that.jcrop = this;
  });
};

PostIllustrationEditor.prototype.destroyJCrop = function() {
  if (this.jcrop) {
    this.jcrop.destroy();

    $('[data-js=post-illustration-jcrop-image]').removeAttr('style');
  }
};

PostIllustrationEditor.prototype.saveCoordinates = function (coordinates) {
  $("#illustration_x").val(coordinates.x);
  $("#illustration_y").val(coordinates.y);
  $("#illustration_x2").val(coordinates.x2);
  $("#illustration_y2").val(coordinates.y2);
};

PostIllustrationEditor.prototype.initPreview = function (src) {
  $('[data-js=post-illustration-image]').attr('src', src);
};

PostIllustrationEditor.prototype.updatePreview = function (coordinates) {
  var $wrapper = $('[data-js=post-illustration]'),
      $illustration = $('[data-js=post-illustration-image]'),
      rx, ry;

  this.saveCoordinates(coordinates);

  if (coordinates.w > 0 && coordinates.h > 0) {
    rx = $wrapper.width() / coordinates.w;
    ry = $wrapper.height() / coordinates.h;

    $illustration.css({
      'width': [Math.round(rx * this.boundX), 'px'].join(''),
      'height': [Math.round(ry * this.boundY), 'px'].join(''),
      'marginLeft': ['-', Math.round(rx * coordinates.x), 'px'].join(''),
      'marginTop': ['-', Math.round(ry * coordinates.y), 'px'].join('')
    });
  }
};

PostIllustrationEditor.prototype.initScale = function(src) {
  var $jcropImage, image, widthRatio, heightRatio, realWidth, readHeight;

  $jcropImage = this.initJCrop();
  realWidth = $jcropImage.width();
  readHeight = $jcropImage.height();

  image = new Image();
  image.onload = function() {
    widthRatio = this.width / realWidth;
    heightRatio = this.height / readHeight;
    $("#illustration_scale").val(widthRatio > heightRatio ? widthRatio : heightRatio);
  };
  image.src = src;
};
