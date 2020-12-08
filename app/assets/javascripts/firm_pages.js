$(document).ready(function() {
  $('[data-js=firm-page-remove-button]').on('click', function(e) {
    e.preventDefault();

    $('.sv-firm-page-remove-popup').toggle();
  })
});
