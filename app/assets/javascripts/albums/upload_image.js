function initPhotosUploader() {
  $('#upload_photos').fileupload({
    uploadTemplateId: null,
    downloadTemplateId: null,
    autoUpload: true,
    sequentialUploads: false,
    singleFileUploads: false,
    dataType: 'script',
    add: function (e, data) {
      data.submit();
    }
  }).bind('fileuploadstart', function() {
      $('html').css('cursor', 'wait');
    });
};

$(document).ready(function() {
  initPhotosUploader();
});