function AlbumForm(albumId) {
  this.albumId = albumId;
  this.$form = $('[data-js=album-photos-form]');

  this.initForm();
}

AlbumForm.prototype.initForm = function() {
  var $photo, that;

  that = this;

  this.$form.on('submit', function() {
    $(this).find('.sv-album-photos-form__photo').each(function(index, photo) {
      $photo = $(photo);

      if (($photo.find('[name*=photo_album_id]').val() != that.albumId) && ($photo.data('saved'))) {
        $photo.remove();
      }
    });
  });
};