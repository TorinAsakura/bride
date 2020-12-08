function AuxiliaryViewer(html) {
  this.$elem = $('#edit_auxiliary');
  this.offset = $('.fancybox-overlay').scrollTop();

  this.$elem.html(html);
}

AuxiliaryViewer.prototype.afterClose = function () {
  window.auxiliaryViewer = null;

  if (window.modalViewer && !this.allowClose) {
    window.modalViewer.show(this.offset);
  }
};

AuxiliaryViewer.prototype.show = function () {
  var that = this;

  $.fancybox.open(this.$elem, {
    'fitToView': false,
    'scrolling': 'no',
    'padding': 0,
    'afterClose': function () {
      that.afterClose();
    }
  });

  $('[data-js=attachment-close]').on('click', function (e) {
    e.preventDefault();

    $.fancybox.close();
  });
};