function IdeaCategorySelector() {
  $('[data-js=section-select]').on('click', function() {
    $('.sv-ideas__section-popup').toggleClass('sv-ideas__section-popup_visible');
  });
}