function PhotoForm(html) {
  ModalViewer.apply(this, [window.photoLocation, window.location, html]);
}

extendViewer(PhotoForm);