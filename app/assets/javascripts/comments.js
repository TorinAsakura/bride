$(document).ready(function () {
  $('.sv-comments__block').infinitescroll({
    'navSelector': '.sv-comments-hidden-nav',
    'nextSelector': '.sv-comments-hidden-nav link[rel=next]',
     'itemSelector': '.sv-comment'
  });
});
