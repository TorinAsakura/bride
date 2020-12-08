function VideoViewer() {
  ModalViewer.apply(this, arguments);
}

extendViewer(VideoViewer);

VideoViewer.prototype.beforeShow = function() {
  ModalViewer.prototype.beforeShow.call(this);

  initVideoPlayer();
};