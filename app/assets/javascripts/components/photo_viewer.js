function PhotoViewer(modalLocation, baseLocation, html) {
  window.photoLocation = modalLocation;
  ModalViewer.apply(this, arguments);
}

extendViewer(PhotoViewer);

PhotoViewer.prototype.beforeShow = function() {
  ModalViewer.prototype.beforeShow.call(this);

  align_center();

  $('[data-js=photo-fullsize]').load(function() {
    $('[data-js=photo-fullsize]').css('display', 'inline');
    $('[data-js=photo-loading]').remove();
    $.fancybox.update();
  });
};