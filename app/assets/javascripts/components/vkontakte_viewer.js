function VkontakteViewer() {
  ModalViewer.apply(this, arguments);
}

extendViewer(VkontakteViewer);

VkontakteViewer.prototype.beforeShow = function () {
  ModalViewer.prototype.beforeShow.call(this);
};
