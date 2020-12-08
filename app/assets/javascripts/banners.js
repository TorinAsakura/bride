$(document).ready(function() {
  var $radio = $('[data-js=admin-banner-type]'),
      $checkboxes = $('.sv-admin-banner-form__visibility');

  var update = function() {
    $(this).is(':checked') && $(this).val() === '0' ? $checkboxes.hide() : $checkboxes.show();
  };

  $radio.on('change', update);
  update.call($radio.filter(':checked').get(0));
});
