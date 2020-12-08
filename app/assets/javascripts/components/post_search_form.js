function PostSearchForm() {
  $('[data-js=posts-search-link]').unbind('click').on('click', function (e) {
    e.preventDefault();

    $('[data-js=post-search-form]').slideToggle();
    $('#sv-read-it').find('li.search a').toggleClass('active');
  });
}