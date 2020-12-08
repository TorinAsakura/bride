$(document).ready(function() {
  $('[data-js=photo-preview-list]').infinitescroll({
    navSelector: '.sv-photos-hidden-nav',
    nextSelector: '.sv-photos-hidden-nav link[rel=next]',
    itemSelector: '[data-js=photo-preview]'
  });
});