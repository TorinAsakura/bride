function ClientInfoViewer() {
  var $clientInfo = $('[data-js=client-info]');

  $('[data-js=client-info-link]').on('click', function (e) {
    e.preventDefault();

    $('.sv-client-info').toggleClass('sv-client-info_full');

    $clientInfo.slideToggle({
      'complete': function () {
        $clientInfo.toggleClass('sv-client-info__list_hidden');
      }
    });
    $(this).toggleClass('icon-chevron-down').toggleClass('icon-chevron-up');
  });
}