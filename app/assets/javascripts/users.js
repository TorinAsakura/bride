$(document).ready(function() {
  
  // change password start
    var canAjaxFlagPassword = true;

    $(document).on('focusout, keyup', '#user_current_password, #user_password, #user_password_confirmation', function(){
      if (canAjaxFlagPassword) {
        canAjaxFlagPassword = false;

        setTimeout(function(){
          canAjaxFlagPassword = true;

          currentUserPassword = $('#user_current_password').val();
          userPassword = $('#user_password').val();
          userPasswordConfirmation = $('#user_password_confirmation').val();

          $('.password-changed').hide();

          flagShowSubmitButton = true;

          if (currentUserPassword != undefined) {
            if (currentUserPassword.length == 0) {
              $('#sv-user-password div.notification.current-password').show();
              flagShowSubmitButton = false;
            } else {
              $('#sv-user-password div.notification.current-password').hide();
            }
          }

          if (userPassword.length < 6) {
            $('#sv-user-password div.notification.password-too-short').show();
            flagShowSubmitButton = false;
          } else {
            $('#sv-user-password div.notification.password-too-short').hide();
          }

          if (userPassword != userPasswordConfirmation) {
            $('#sv-user-password div.notification.password-dont-confirmated').show();
            flagShowSubmitButton = false;
          } else {
            $('#sv-user-password div.notification.password-dont-confirmated').hide();
          }

          if (flagShowSubmitButton == true) {
            $('#sv-user-password [type=submit]').show();
          } else {
            $('#sv-user-password [type=submit]').hide();
          }
        }, 1000);
      }
    });
  // change password end

});

