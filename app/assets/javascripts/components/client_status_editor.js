function ClientStatusEditor() {
  $('[data-js=client-status]').on('click', function (e) {
    e.preventDefault();

    var $editor = $('.sv-client-status-edit');

    $('.sv-client-status').addClass('sv-client-status_hidden');
    $editor.find('[data-js=client-status]').focus().select();
    $editor.removeClass('sv-client-status-edit_hidden');
  });
}