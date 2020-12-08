// clients#edit
$(document).ready(function() {
  $(document).on('click', '.sv-client-friends-section', function(e) {
    e.preventDefault();
    form = $('#client-search-form')
    hiddenSectionInput = $('#sv-client_search-section');
    hiddenSectionInput.val($(this).attr('section'));
    form.submit();
  });

  $(document).on('click', '.sv-end-form a.sv-confirm-button', function() {
    $(this).parent().find(".notification").show();
    return false;
  });

  $(document).click(function(event) {
    if (!$(event.target).closest(".notification").length) {
      $(".sv-end-form a.sv-confirm-button").parent().find(".notification").hide();
    }
  });

  $(document).on('click', '.couple-button', function(e){
    e.preventDefault();
    $(e.currentTarget).prev().toggleClass('visible');
  })

  $(document).on('click', '.change-couple-button', function(e){
    $(e.currentTarget).prev().toggleClass('visible');
    $( "#change-couple-form" ).submit();
  });

  if ($('.client-edit').length != 0) {

    function initPartEditFormClient () {
      hideAllPartEditFormClient();
      removeClassActiveFromAllPartEditFormClient();

      var anchor = document.URL.split('#')[1];
      if ( anchor == undefined || anchor == '' ) {
        showPartEditFormClient($('#client-control-panel-base-settings'));
        addClassActiveToPartEditFormClient($('[data-part=client-control-panel-base-settings]'));
      } else {
        showPartEditFormClient( $('#' + $('.' + anchor).attr('data-part')) );
        addClassActiveToPartEditFormClient($('.' + anchor));
      }
    }

    function hideAllPartEditFormClient () {
      $('.client-settings').hide();
    }

    function removeClassActiveFromAllPartEditFormClient () {
      $('.client-control-panel-link').parents('li').removeClass('active');
    }

    function showPartEditFormClient (partID) {
      partID.show();
    }

    function addClassActiveToPartEditFormClient (partID) {
      partID.parents('li').addClass('active');
    }

    // change phone
      $(document).on('click', '#client-phone input', function(){
        $('#client-phone span.result.updated').hide();
        $('#client-phone .field-block .notification').show();
        $('#client-phone [type=submit]').show();
      })
    // end change phone

    // change email start
      function validateEmail(email) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
      }

      function checkPresentOfEmail (email) {
        $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/users/check_email_present',
          {
            user_email: email
          },
          function(data, textStatus) {
            $('#client-user-email span').hide();
            if(data.result == true) {
              $('#client-user-email [type=submit]').hide();
              $('#client-user-email span.result.not-free').show();
            } else {
              $('#client-user-email [type=submit]').show();
              $('#client-user-email span.result.free').show();
            }
          }
        );

        return false;
      }

      function emailValidAction() {
        if (canAjaxFlagEmail) {
          canAjaxFlagEmail = false;
          var emailInput = $('#sv-client-input-email');
          setTimeout(function(){
            canAjaxFlagEmail = true;
            var curentEmail = emailInput.val();

              if (validateEmail(curentEmail)) {
                userEmail = curentEmail;
                checkPresentOfEmail(curentEmail);
              } else {
                $('#client-user-email [type=submit]').hide();
                $('#client-user-email span.result').hide();
                $('#client-user-email span.not-valid').show();
              }
          }, 1000);
        } 
      } 

      var userEmail = $('#sv-client-input-email').val();
      var canAjaxFlagEmail = true;
      $(document).on('mousedown, keyup', '#sv-client-input-email', function(){
        emailValidAction(); 
      });
      $(document).on('change', '#sv-client-subscr-checkbox', function(){
        emailValidAction(); 
      });

    // cange email end

    // change profile settings
      $(document).on('click', '#client-profile-settings input:not(.city-selector), #client-profile-settings select', function(){
        $('#client-profile-settings span.result.updated').hide();
        $('#client-profile-settings [type=submit]').show();
      })
    // end change profile settings

    $(document).on('click', '.client-control-panel-link', function() {
      hideAllPartEditFormClient();
      removeClassActiveFromAllPartEditFormClient();

      showPartEditFormClient($( '#' + $(this).attr('data-part') ));
      addClassActiveToPartEditFormClient($(this));
    })

    $(document).on('click', 'a.client-control-panel-link.black-list-settings.link-style.input-big', function(){
        $(this).closest('.sv-wrapper.client-edit').find('li a.client-control-panel-link.black-list-settings').closest('li').addClass('active')
    })

    //init part of edit page
    initPartEditFormClient();
  }

  $('.sv-wedding-without-date').change(function() {
    $('[data-js=wedding-calc]').toggle();
    $('[data-js=wedding-radio]').toggle();
    $('.create-wedding select').each(function() {
      this.disabled = !this.disabled;
    });
  });

});

$(document).ready(function() {
//start - javascript for creating/updating wedding
  $('#day, #month, #year').bind('change', function(){
    calcWeeks();
  });
  $('#create-type').click(function(){
    calcWeeks();
  });

  $.fancybox.open($('#confirm'), { fitToView: false, scrolling: 'no'});

  //переключатель типа создания свадьбы
  $( "#site_user" ).click(function() {
    $('.select-alone, .select-handly-type').css('display', 'none');
    $('.select-site-user').css('display', 'block');
  });
  $( "#handly_type" ).click(function() {
    $('.select-alone, .select-site-user').css('display', 'none');
    $('.select-handly-type').css('display', 'block');
  });
});

function calcWeeks(){
  var day = $("#day option:selected").text();
  var month = $("#month option:selected").val();
  var year = $("#year option:selected").text();
  if (day != 'День' && month != 'Месяц' && year != 'Год'){
    var bigEvent = Date.UTC(year, month, day);
    var date = new Date();
    if ($('#edit_date').is(":checked") == true){
      var date_arr = $('[data-js=start-scheduler-date]').text().split(".")
      var today = Date.UTC(date_arr[2], date_arr[1], date_arr[0]);
    }
    else{
      var today = Date.UTC(date.getFullYear(), date.getMonth() + 1, date.getDate());
    }
    var days = (bigEvent - today)/(1000*60*60*24);
    var week = Math.floor(days / 7)
    if (week > 0)
      $('[data-js=before-scheduler-date]').html(['До вашей свадьбы: ', days, ' дней (', week, ' недель)'].join(''));
    else
     $('[data-js=before-scheduler-date]').text('');
  }
  else{
   $('[data-js=before-scheduler-date]').text('');
  }
}

$(document).ready(function () {
  new ClientStatusEditor();
  new ClientAvatarEditor();
  new ClientInfoViewer();
  new CitySelector();

  $('[data-js=client-avatar-destroy]').on('click', function(e) {
    e.preventDefault();

    $.fancybox.open('#sv-remove-client-avatar', {
      'fitToView': false,
      'scrolling': 'no',
      'helpers' : {
        'overlay' : {
          'closeClick': false
        }
      }
    })
  });

  $('[data-js=client-avatar-destroy-confirm]').on('click', function (e) {
    $.fancybox.close();
  });

  $('[data-js=client-settings-update-city]').on('click', function() {
    $.fancybox.open($('#sv-wedding-cities'));
  });

  calcWeeks();
});
