$(document).ready(function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      window.CompetitionPreview = $(input).parents('.control-group').children().children('img');
      reader.onload = function (e, preview) {
        $(window.CompetitionPreview)
          .attr('src', e.target.result);
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  function isValidDates() {
    if ($('#competition_start_date').length == 0) {
      return false;
    }
    startDateArray = $('#competition_start_date').val().split('-');
    endDateArray = $('#competition_deadline_date').val().split('-');

    startDate = new Date(startDateArray[2], startDateArray[1], startDateArray[0])
    endDate = new Date(endDateArray[2], endDateArray[1], endDateArray[0])

    if (endDate<startDate) {
      $('#submit').hide();
      $('.error-date.lower').show();
      $('.error-date.equally').hide();
      $('.datepicker').addClass('error');
    } else if ((endDate - startDate) == 0) {
      $('#submit').show();
      $('.error-date.lower').hide();
      $('.error-date.equally').show();
      $('.datepicker').addClass('error');
    } else {
      $('#submit').show();
      $('.error-date').hide();
      $('.datepicker').removeClass('error');
    }
  }

  isValidDates();

  $('.competition .datepicker').datepicker({
    dateFormat: "dd-mm-yy"
  });

  $('.competition .datepicker').change(function() {
    isValidDates();
  });

  $("#competition_banner").change(function() {
    readURL(this);
  });

  $(document).on("change", ".competition-prize-input", function(e) {
    readURL(this);
  });

  $(document).on("click", ".unlike-album", function(e) {
    var element = e.currentTarget;
    var album_id = $(element).attr('album_id');
    $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/competitions/unlike_album?album_id='+album_id,
      {},
      function() {}
    );
  });

  $(document).on("click", ".like-album", function(e) {
    var element = e.currentTarget;
    var album_id = $(element).attr('album_id');
    $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/competitions/like_album?album_id='+album_id,
      {},
      function() {}
    );
  });

  
  $(document).on('click', '.competition .remove_fields', function (event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    $(this).closest('fieldset').find('input, textarea').attr('required', false);
    event.preventDefault();
  });
});
