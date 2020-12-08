function PollViewer() {
  ModalViewer.apply(this, arguments);
}

extendViewer(PollViewer);

PollViewer.prototype.beforeShow = function () {
  ModalViewer.prototype.beforeShow.call(this);

  initAccordion();
};