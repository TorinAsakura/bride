function VideoForm(html) {
  ModalViewer.apply(this, [window.location, window.location, html]);

  this.$form = $('[data-js=video-form]');
  this.$urlInput = this.$form.find('[data-js=video-url-input]');
  this.$error = $('[data-js=video-form-error]');

  this.initForm();
}

extendViewer(VideoForm);

VideoForm.prototype.beforeShow = function () {
  ModalViewer.prototype.beforeShow.call(this);

  searchTags();
};

VideoForm.prototype.validateUrl = function (url) {
  var vk_regexp = new RegExp("video.[0-9]+._[0-9]+", "i");
  var vimeo_regex = new RegExp("\/\/vimeo.com\/[0-9]+$", "i");
  var youtube_regexp = new RegExp("youtube.com", "i");
  var bool = (url.match(vk_regexp) || url.match(vimeo_regex) || url.match(youtube_regexp)) ? true : false;
  return bool;
};

VideoForm.prototype.initForm = function () {
  var that = this;

  this.$form.on('submit', function (e) {
    if (!that.validateUrl(that.$urlInput.val())) {
      e.preventDefault();

      window.auxiliaryViewer = new AuxiliaryViewer(that.$error.html());
      window.auxiliaryViewer.show();
    }
  });
};
