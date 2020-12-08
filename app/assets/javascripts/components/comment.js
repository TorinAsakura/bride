function Comment(options) {
  this.$elem      = $(options.element);
  this.$parent    = $(options.parent);
  this.imageClass = options.imageClass;
  this.images     = options.images;
  this.hrefs      = options.hrefs;

  this.initImages('[data-js=comment-images-first]', this.images.slice(0, 3), this.hrefs.slice(0, 3));
  this.initImages('[data-js=comment-images-second]', this.images.slice(3, 6), this.hrefs.slice(3, 6));
  this.initEditor();
}

Comment.prototype.initImages = function (container, images, hrefs) {
  var verticalImages = [],
      horizontalImages = [],
      promises = [],
      that = this;

  $.each(images, function (index, url) {
    var image = new Image(),
        deferred = new $.Deferred();

    image.onload = function () {
      (image.width > image.height ? horizontalImages : verticalImages).push({
        'resource': url,
        'action': hrefs[index]
      });
      deferred.resolve();
    };

    promises.push(deferred.promise());
    image.src = url;
  });

  $.when.apply($, promises).then(function () {
    that.showImages(container, verticalImages, horizontalImages);
  });
};

Comment.prototype.showImages = function (container, verticalImages, horizontalImages) {
  var imageClass,
      that = this,
      vlength = verticalImages.length,
      hlength = horizontalImages.length,
      handler;

  imageClass = [this.imageClass, ' ', 'sv-comment__image_', vlength, 'v', hlength, 'h'].join('');

  handler = function (e) {
    e.preventDefault();

    $.getScript(this.href);
  };

  $.each(vlength < hlength ? verticalImages : horizontalImages, function (index, value) {
    $('<a></a>')
      .attr('href', value.action)
      .addClass(imageClass)
      .addClass('sv-comment__image')
      .addClass(['sv-comment__image_', vlength < hlength ? 'vertical' : 'horizontal'].join(''))
      .css('background-image', ['url(', value.resource, ')'].join(''))
      .appendTo(that.$elem.find(container))
      .on('click', handler);
  });

  $.each(vlength >= hlength ? verticalImages : horizontalImages, function (index, value) {
    $('<a></a>')
      .attr('href', value.action)
      .addClass(imageClass)
      .addClass('sv-comment__image')
      .addClass(['sv-comment__image_', vlength >= hlength ? 'vertical' : 'horizontal'].join(''))
      .css('background-image', ['url(', value.resource, ')'].join(''))
      .appendTo(that.$elem.find(container))
      .on('click', handler);
  });
};

Comment.prototype.initEditor = function () {
  var $formWrapper = this.$parent.find('[data-js=comment-edit-form-wrapper]'),
      $form = this.$parent.find('[data-js=comment-edit-form]'),
      $template = $form.find('.sv-comment-edit-form__image-wrapper_template'),
      $imagesWrapper = $form.find('[data-js=comment-edit-images]'),
      $image,
      imagesToRemove = [],
      that = this,
      showForm,
      hideForm;

  showForm = function () {
    $formWrapper
      .detach()
      .removeClass('sv-comment-edit-form_hidden')
      .appendTo(that.$elem);
    $form
      .attr('action', that.$elem.data('url'));
    $form
      .find('[data-js=comment-edit-body]')
      .val(that.$elem.data('body'));
    $.each(that.images, function (index, url) {
      $image = $template
        .clone()
        .removeClass('sv-comment-edit-form__image-wrapper_template')
        .appendTo($imagesWrapper);
      $image
        .find('[data-js=comment-edit-image]')
        .attr('src', url);
      (function ($image, href) {
        $image
          .find('[data-js=comment-edit-image-destroy]')
          .on('click', function (e) {
            e.preventDefault();

            imagesToRemove.push(href);
            $image.fadeOut();
          });
      })($image, that.hrefs[index]);
    });
    that.$elem.find('.sv-comment__body, .sv-comment__images, .sv-comment__video, .sv-comment__actions').hide();
  };

  hideForm = function () {
    $formWrapper.find('.sv-comment-edit-form__image-wrapper:not(.sv-comment-edit-form__image-wrapper_template)').remove();
    $formWrapper
      .detach()
      .addClass('sv-comment-edit-form_hidden')
      .appendTo(that.$parent);
    that.$elem.find('.sv-comment__body, .sv-comment__images, .sv-comment__video, .sv-comment__actions').show();
  };

  this.$elem.find('[data-js=comment-edit-btn]').on('click', function (e) {
    e.preventDefault();

    showForm();
  });

  this.$elem.find('[data-js=comment-destroy]').on('click', function () {
    hideForm();
  });

  $form.find('[data-js=comment-edit-cancel]').on('click', function (e) {
    e.preventDefault();

    hideForm();
  });

  $form.on('submit', function () {
    $.each(imagesToRemove, function () {
      $.ajax({
        'url': this,
        'type': 'post',
        'dataType': 'json',
        'data': {
          '_method': 'delete'
        }
      });
    });

    hideForm();
  });
};