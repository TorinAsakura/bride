function PhotoEditForm(photo, select, url) {
  this.$photo = $(photo);
  this.$select = $(select);
  this.url = url;

  this.initSelect();
  this.initButtons();
}

PhotoEditForm.FADEOUT_DURATION = 400;

PhotoEditForm.prototype.initSelect = function() {
  this.$select.select2({ 'minimumResultsForSearch': -1 });
};

PhotoEditForm.prototype.initButtons = function() {
  var data, that;

  that = this;

  this.$photo.find('[data-js=album-photos-form-photo-btn-remove]').on('click', function(e) {
    e.preventDefault();

    that.$photo.fadeOut(PhotoEditForm.FADEOUT_DURATION, function() {
      that.$photo.remove();
      if ($('.sv-album-photos-form__photo').length == 0) {
        $('.sv-album-photos-form__separator').hide();
      }
    });
  });

  this.$photo.find('[data-js=album-photos-form-photo-btn-save]').on('click', function(e) {
    e.preventDefault();

    data = {
      '_method': 'put',
      'photo' : {
        'description': that.$photo.find('[name*=description]').val(),
        'photo_album_id': that.$photo.find('[name*=photo_album_id]').val()
      }
    };

    $.ajax({
      'url': that.url,
      'type': 'post',
      'data': data,
      'dataType': 'json',
      'success': function() {
        that.$photo.data('saved', 'true');
      }
    });
  });
};