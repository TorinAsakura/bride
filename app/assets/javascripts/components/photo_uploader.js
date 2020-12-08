function PhotoUploader(switchTab) {
  if (switchTab) {
    this.switchTab();
  }

  this.$photosForm = $('[data-js=album-photos-form]');
  this.$select = $('[data-js=album-select]');
  this.$file = this.$photosForm.find('input[type=file]');
  this.totalData = [];

  this.initSelect();
  this.initUploader();
  this.update();
}

PhotoUploader.prototype.switchTab = function() {
  $('.sv-modal-tabs li').show();
  $('.sv-modal-tabs li:not(:active) a').trigger('click');
};

PhotoUploader.prototype.getParams = function() {
  return {
    'id': this.$select.val(),
    'url': [this.$photosForm.data('albums'), this.$select.val(), 'upload_photo'].join('/')
  }
};

PhotoUploader.prototype.initSelect = function() {
  var that = this;

  this.$select
    .on('change', function() { that.update() })
    .select2({ 'minimumResultsForSearch': -1 });
};

PhotoUploader.prototype.initUploader = function() {
  var params = this.getParams(),
    that = this,
    options = {
      'url':                params['url'],
      'type':               'post',
      'dataType':           'script',
      'uploadTemplateId':   null,
      'downloadTemplateId': null,
      'singleFileUploads':  true,
      'sequentialUploads':  true,
      'progressInterval':   0,
      'add':                function (e, data) { that.totalData.push(data); }
    };

  this.$file.change(function() {
    if (this.files && this.files[0]) {
      $.ajax({
        'url': that.$photosForm.attr('action'),
        'type': 'post',
        'dataType': 'script',
        'data': {
          '_method': 'put',
          'upload' : true,
          'album': { 'id': params['id'] }
        }
      });
    }
  });

  this.$photosForm.fileupload(options);
};

PhotoUploader.prototype.update = function() {
  var params = this.getParams();

  this.$photosForm.attr('action', [this.$photosForm.data('albums'), params['id']].join('/'));
  this.$photosForm.fileupload('option', 'url', params['url']);
};

PhotoUploader.prototype.submit = function() {
  var formData,
    filename,
    that = this;

  return function(callback) {
    that.$photosForm.fileupload('option', 'type', 'post');
    $.each(that.totalData, function(index, data) {
      filename = data.files[0].name;

      formData = that.$photosForm.serializeArray();
      formData.push({
        'name': 'filename',
        'value': filename
      });

      that.$photosForm.fileupload('option', 'formData', formData);
      that.$photosForm.fileupload('send', { 'files': data.files });

      window.modalViewer.preventClose = true;

      callback(filename);
    });
  }
};

function PhotoUploaderProgress(submit) {
  var that = this;

  $.fancybox.update();

  $('.sv-album-form').addClass('sv-album-form_hidden');

  $('[data-js=album-photos-form]').bind('fileuploadprogress', function(e, data) {
    that.updateProgressBar(data.files[0].name, (data.loaded / data.total) * 100);
  });

  submit(this.addProgressBar);
}

PhotoUploaderProgress.prototype.addProgressBar = function(filename) {
  var $progress = $('.sv-album-photos-form__progress_template');

  $progress
    .clone()
    .removeClass('sv-album-photos-form__progress_template')
    .attr('data-filename', filename)
    .appendTo('.sv-album-photos-form__uploads')
};

PhotoUploaderProgress.prototype.updateProgressBar = function(filename, progress) {
  var $progress = $('[data-filename="' + filename + '"]');

  $progress
    .find('.sv-album-photos-form__progress-inner')
    .css('width', progress + '%');
};

PhotoUploaderProgress.prototype.complete = function(filename, html) {
  $.fancybox.update();

  $('[data-filename="' + filename + '"]').replaceWith(html);
};
