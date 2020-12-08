$(function () {
  $('#fileupload-avatar').fileupload({
      dataType: 'json',
      uploadTemplateId: null,
      downloadTemplateId: null,
      autoUpload: true,
      done: function (e, data) {
        $("#avatar").attr("src", data.result.avatar);
      },
      start: function (e, data) {
        $("#avatar").addClass("loading")
      },
      stop: function (e, data) {
        $("#avatar").removeClass("loading")
      },
  });
});