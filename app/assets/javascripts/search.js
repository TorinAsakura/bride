$(document).ready(function () {

  $(document).on('click', '#sv-reset-city-select', function(e){
    e.preventDefault();
    $(this).siblings('input').select2('val', '');
  });

  $(document).on('click', '.sv-search-sort', function(e){
    e.preventDefault();
    sortHiddenInput = $('#sv-search-sort-type');
    orderHiddenInput = $('#sv-search-order-type');

    sortHiddenInput.val($(this).attr('sort'));
    (orderHiddenInput.val() == 'ASC' ) ? orderHiddenInput.val('DESC') : orderHiddenInput.val('ASC');
    $(this).removeClass('DESC ASC').addClass(orderHiddenInput.val());

    $('.sv-search-sort').removeClass('active DESC ASC');
    $(this).addClass(orderHiddenInput.val());

    $(this).addClass('active');
    sortHiddenInput.parents('form').submit();
  });
});

function removeInfinitescroll() {
  infScroll = $('.sv-search-result');
  infScroll.infinitescroll('binding','unbind');
  infScroll.data('infinitescroll', null);
  $(window).unbind('.infscr');
}

function infinitescrollClients() {
  infScroll = $('#sv-search-clients-result');
  infScroll.infinitescroll({
    'navSelector': '.sv-clients__nav',
    'nextSelector': '.sv-clients__nav a.next',
    'itemSelector': '.sv-search-client__block'
  });
}

function infinitescrollMiniSites() {
  infScroll = $('#sv-search-minisites-result');
  infScroll.infinitescroll({
    'navSelector': '.sv-minisites__nav',
    'nextSelector': '.sv-minisites__nav a.next',
    'itemSelector': '.sv-search-minisite__block'
  });
}

function infinitescrollPosts() {
  infScroll = $('[data-js=post-list]');
  infScroll.infinitescroll({
    'navSelector': '.sv-posts-hidden-nav',
    'nextSelector': '.sv-posts-hidden-nav a.next',
    'itemSelector': '[data-js=post]'
  });
}

function infinitescrollFirms() {
  infScroll = $('#sv-firm-search-result');
  infScroll.infinitescroll({
    'navSelector': '#sv-firms-paginate',
    'nextSelector': '#sv-firms-paginate a.next',
    'itemSelector': '.sv-item-firm'
  });
}

function infinitescrollEventIdeas() {
  $('#sv-ideas-list [data-js=ideas-list]').infinitescroll({
    navSelector: '.sv-ideas-hidden-nav',
    nextSelector: '.sv-ideas-hidden-nav a.next',
    itemSelector: '[data-js=idea]'
  });
}

function infinitescrollEventVideo() {
  $('#sv-video-list [data-js=video-list]').infinitescroll({
    navSelector: '.sv-video-hidden-nav',
    nextSelector: '.sv-video-hidden-nav a.next',
    itemSelector: '[data-js=video]'
  },function(){
    initVideoPreviews();
  });
}
