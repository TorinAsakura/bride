function AttachmentPhotoUploader(options) {
  this.wrapper               = options.wrapper;
  this.$wrapper              = $(options.wrapper);
  this.$fileWrapper          = options.fileWrapper ? this.$wrapper.find(options.fileWrapper) : this.$wrapper;
  this.fileField             = options.fileField;
  this.$button               = this.$wrapper.find(options.button);
  this.$images               = this.$wrapper.find(options.images);
  this.imagesEmptyClass      = options.imagesEmptyClass;
  this.$progressTemplate     = this.$wrapper.find(options.progressTemplate);
  this.progressTemplateClass = options.progressTemplateClass;
  this.image                 = options.image;
  this.imageTemplate         = options.imageTemplate;
  this.$imagesCount          = $(options.imagesCountInput);

  this.initButton();
  this.initUploader();
}

AttachmentPhotoUploader.prototype.initButton = function () {
  var that = this;

  this.$button.on('click', function (e) {
    e.preventDefault();

    $([that.wrapper, that.fileField].join(' ')).trigger('click');
  });
};

AttachmentPhotoUploader.prototype.initUploader = function () {
  var that = this;

  this.$fileWrapper.fileupload({
    'dataType':           'script',
    'filesContainer':     that.$images,
    'uploadTemplateId':   that.imageTemplate,
    'downloadTemplateId': null,
    'previewMaxWidth':    300,
    'previewMaxHeight':   150,
    'multipart':          true,
    'singleFileUploads':  true,
    'sequentialUploads':  true
  }).bind('fileuploadadd', function () {
    that.$images.removeClass(that.imagesEmptyClass);

  }).bind('fileuploadprogress', function (e, data) {
    $.each(data.files, function (index, file) {
      file.progress.updateProgressBar(data.loaded / data.total);
    });

  }).bind('fileuploaddone', function (e, data) {
    $.each(data.files, function (index, file) {
      file.$template.show();
      file.progress.remove();
    });
  });

  $([this.wrapper, this.fileField].join(' ')).on('change', function () {
    if (that.$imagesCount.length > 0) {
      that.$imagesCount.val(that.getFiles().length);
    }

    if (window.commentForm) {
      window.commentForm.updatePosition(true);
    }
  });
};

AttachmentPhotoUploader.prototype.getFiles = function () {
  var files = [];

  this.$wrapper.find('.template-upload').each(function () {
    $.each($(this).data('data').files, function () {
      files.push(this);
    });
  });

  return files;
};

AttachmentPhotoUploader.prototype.send = function (url, callback) {
  var files = this.getFiles(),
      that = this,
      getTemplate,
      getId,
      template,
      progress;

  getTemplate = function(file) {
    var $template,
        $result = null;

    $.each(that.$wrapper.find('.template-upload'), function (index, template) {
      $template = $(template);

      if ($template.data('data').files[0].externalId === file.externalId) {
        $result = $template;
      }
    });

    return $result;
  };

  getId = (function () {
    var id = 0;

    return function () {
      return id++;
    }
  })();

  if (files.length > 0) {
    this.$fileWrapper.fileupload('option', 'url', url);
    this.$fileWrapper.bind('fileuploadstop', function () {
      callback();
    });

    $.each(files, function (index, file) {
      progress = that.$progressTemplate.clone()
        .removeClass(that.progressTemplateClass)
        .appendTo(that.$images);

      file.externalId = getId();
      file.progress = new AttachmentPhotoProgress(progress);
      file.$template = getTemplate(file);
      file.$template.hide();

      that.$fileWrapper.fileupload('send', {
        'files': [file]
      })
    });
  } else {
    callback();
  }
};

AttachmentPhotoUploader.prototype.reset = function () {
  if (this.$imagesCount.length > 0) {
    this.$imagesCount.val(0);
  }

  this.$images.find(this.image).remove();
  this.$images.addClass(this.imagesEmptyClass);
};

AttachmentPhotoUploader.prototype.getUploadsCount = function () {
  return this.getFiles().length;
};

function AttachmentPhotoProgress($element) {
  this.$elem = $element;
}

AttachmentPhotoProgress.prototype.updateProgressBar = function (progress) {
  this.$elem.find('[data-js=progress-bar]').css('width', (progress * 100) + '%');
};

AttachmentPhotoProgress.prototype.remove = function (callback) {
  this.$elem.remove();
};