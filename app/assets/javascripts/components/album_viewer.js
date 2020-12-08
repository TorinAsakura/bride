function AlbumViewer() {
  ModalViewer.apply(this, arguments);

  $(document).on('click', '[data-js=album-form-warning-ok]', function (e) {
    e.preventDefault();

    window.auxiliaryViewer.allowClose = true;
    $.fancybox.close();
  });

  $(document).on('click', '[data-js=album-form-warning-cancel]', function (e) {
    e.preventDefault();

    $.fancybox.close();
  });
}

extendViewer(AlbumViewer);

AlbumViewer.prototype.afterClose = function () {
  if (this.preventClose) {
    window.auxiliaryViewer = new AuxiliaryViewer($('[data-js=album-form-warning]').html());
    window.auxiliaryViewer.show();
  }
};