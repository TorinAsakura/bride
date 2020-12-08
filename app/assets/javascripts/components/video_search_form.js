function VideoSearchForm() {
  this.initToggleButton();
  this.initSearchTypeButtons();
}

VideoSearchForm.prototype.initToggleButton = function () {
  $('[data-js=videos-search]').unbind('click').on('click', function(e) {
    e.preventDefault();

    $('[data-js=videos-search-form]').slideToggle();
    $('#sv-videos-block').find('li.search').find('a').toggleClass('active');
  });
};

VideoSearchForm.prototype.initSearchTypeButtons = function () {
  var $this, $buttons, $field;

  $buttons = $('.sv-videos-search-form__link');
  $field = $('[data-js=video-search-type]');
  $('[data-search-type="' + $field.val() + '"]').addClass('sv-videos-search-form__link_active');

  $buttons.on('click', function (e) {
    e.preventDefault();

    $this = $(this);
    $buttons.removeClass('sv-videos-search-form__link_active');
    $this.addClass('sv-videos-search-form__link_active');
    $field.val($this.data('search-type'));
  });
};