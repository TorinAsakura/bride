function IdeaViewer(modalLocation, baseLocation, html) {
  window.ideaLocation = modalLocation;
  ModalViewer.apply(this, arguments);
}

extendViewer(IdeaViewer);

IdeaViewer.prototype.beforeShow = function() {
  ModalViewer.prototype.beforeShow.call(this);

  $('[data-js=idea-fullsize]').load(function() {
    $('[data-js=idea-fullsize]').css('display', 'inline');
    $('[data-js=idea-loading]').remove();
    $.fancybox.update();
  });

  $(document).on('click', $('[data-js=idea-add-button]'), function(e) {
    if (e.which === 2) {
      e.preventDefault();

      var $target = $(e.target);

      $.ajax({
        type: 'POST',
        url: $target.attr('href'),
        dataType: 'script'
      });
    }
  });

  $(document).on('click', $('[data-js=idea-remove-button]'), function(e) {
    if (e.which === 2) {
      e.preventDefault();

      var $target = $(e.target);

      $.ajax({
        type: 'POST',
        url: $target.attr('href'),
        dataType: 'script',
        data: {
          '_method': 'DELETE'
        }
      });
    }
  });
};
