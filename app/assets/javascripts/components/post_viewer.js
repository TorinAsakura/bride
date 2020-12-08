function PostViewer() {
  ModalViewer.apply(this, arguments);
}

extendViewer(PostViewer);

PostViewer.prototype.beforeShow = function() {
  ModalViewer.prototype.beforeShow.call(this);

  initVideoPlayer();
  initVideoPreviews();
};