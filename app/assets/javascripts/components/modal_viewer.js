function ModalViewer(modalLocation, baseLocation, html, gallery) {
  var $edit = $('#edit');

  this.modalLocation = modalLocation;
  this.baseLocation = baseLocation;
  this.gallery = !!gallery;

  if ($edit.length == 0) {
     $('body').append('<div id="edit"></div>');
  }

  $edit.html(html);
}

ModalViewer.prototype.beforeShow = function () {
  this.mainCommentForm = window.commentForm;
  if (!this.commentForm) {
    this.commentForm = new CommentForm({
      'element': '#edit',
      'modal': true,
      'multipart': true
    });
    window.commentForm = this.commentForm;
  }

  if (window.history) {
    history.pushState(null, null, this.modalLocation);
  }

  if (window.commentForm) {
    window.commentForm.initStickyForm();
  }
};

ModalViewer.prototype.afterClose = function () {
  if (!window.auxiliaryViewer) {
    if (!this.gallery) {
      window.modalViewer = null;
    }
    window.commentForm = this.mainCommentForm;

    if (window.history) {
      history.pushState(null, null, this.baseLocation);
    }
  }
};

ModalViewer.prototype.show = function (offset) {
  var that = this;

  offset = offset || 0;
  $.fancybox.open($('#edit'), {
    'fitToView': false,
    'scrolling': 'no',
    'padding': 0,
    'beforeShow': function () {
      that.beforeShow();
    },
    'afterShow': function () {
      setTimeout(function () {
        $('.fancybox-overlay').scrollTop(offset)
      }, 100);

      $('.fancybox-overlay').trigger('scroll');
    },
    'afterClose': function () {
      that.afterClose();
    }
  });
};

function extendViewer(ResourceViewer) {
  var F = function () {};
  F.prototype = ModalViewer.prototype;
  ResourceViewer.prototype = new F();
  ResourceViewer.prototype.constructor = ResourceViewer;
}
