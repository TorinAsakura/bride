function MessageForm(wrapper) {
  this.$wrapper = $(wrapper);
  this.$form = this.$wrapper.find('[data-js=message-form]');

  this.initButtons();
  this.initForm();
}

MessageForm.prototype.initButtons = function() {
  var that = this;

  this.$wrapper.find('[data-js=message-form-submit]').on('click', function(e) {
    e.preventDefault();

    that.$form.submit();
  });
};

MessageForm.prototype.initForm = function() {
  var that = this;

  this.$form.on('submit', function() {
    that.$form.ajaxSubmit({
      'dataType': 'json',
      'success': function (response, status, xhr) {
        that.$form.find('input[name=_method]').remove();
        that.messagePhotoUploader.send(xhr.responseJSON.images_url, function() {
          $.getScript(xhr.responseJSON.message_url, function () {
            that.messagePhotoUploader.reset();
            that.messageVideoUploader.reset();

            that.$form.get(0).reset();
          });
        });
      }
    });

    return false;
  });
};
