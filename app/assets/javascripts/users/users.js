$(function () {
  $('#birthday_field').datepicker({weekStart: 1, changeMonth: true,changeYear: true, yearRange: "-40:+0",})
  /*$('#birthday_field').datepicker('update');*/
  $('#wedding_date_field').datepicker({weekStart: 1 });

    $('#fileupload_from').fileupload({
      uploadTemplateId: null,
      downloadTemplateId: null,
      autoUpload: true,
      dataType: 'json',
      done: function (e, data) {
        console.log(data.result)
        $("#uploaded_image").attr("src", data.result.avatar);
      },
      start: function (e, data) {
        $("#uploaded_image").addClass("loading")
      },
      stop: function (e, data) {
        $("#uploaded_image").removeClass("loading")
      },
  });

  $("#create_wedding_with").on('show', function(){
    $('#create_wedding').modal("hide")
  });
});
