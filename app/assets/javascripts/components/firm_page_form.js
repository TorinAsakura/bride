function FirmPageForm(wrapper) {
  this.$wrapper = $(wrapper);
  this.$form = this.$wrapper.find('[data-js=firm-page-form]');

  this.initButtons();
  this.initForm();
}

FirmPageForm.prototype.initButtons = function() {
  var that = this;

  this.$wrapper.find('[data-js=firm-page-form-submit]').on('click', function(e) {
    e.preventDefault();

    that.$form.submit();
  });
};

FirmPageForm.prototype.initForm = function() {
  var that = this;

  this.$form.on('submit', function() {
    that.$form.ajaxSubmit({
      'dataType': 'json',
      'success': function (response, status, xhr) {
        that.$form.find('input[name=_method]').remove();
        that.firmPagePhotoUploader.send(xhr.responseJSON.images_url, function() {
          window.location.reload();
        });
      }
    });

    return false;
  });
};
