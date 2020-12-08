function ColorSearchForm(options) {
  this.$colorInput = $(options.colorInput);
  this.$input = $(options.input);
  this.$tagList = $(options.tagList);
  this.immediate = options.immediate;

  this.init();
}

ColorSearchForm.prototype.init = function() {
  var that = this;

  this.$colorInput.on('change', function() {
    if (that.immediate) {
      window.location = this.getAttribute('data-url');
    } else {
      var inputValue,
          tagListValue;

      inputValue = that.$input.val();
      that.$input.val(_.uniq(inputValue.split(', ').concat(this.getAttribute('data-color'))).join(inputValue.length ? ', ' : ''));

      if (that.$tagList.length) {
        tagListValue = that.$tagList.val();
        that.$tagList.val(_.uniq(tagListValue.split(', ').concat(this.value)).join(tagListValue.length ? ', ' : ''));
      }
    }
  });
};