$(document).ready(function () {
  infinitescrollCommunityPosts();
  new CommunityAvatarEditor();

  $('[data-js=community-avatar-destroy]').on('click', function(e) {
    e.preventDefault();

    $.fancybox.open('#sv-remove-community-avatar', {
      'fitToView': false,
      'scrolling': 'no',
      'helpers' : {
        'overlay' : {
          'closeClick': false
        }
      }
    })
  });

  $('[data-js=community-avatar-destroy-confirm]').on('click', function (e) {
    $.fancybox.close();
  });

 $(document).on('click', '.sv-community__navigation .sv-post-category', function(e) {
   e.preventDefault();
   $(this).toggleClass('active');

   form = $('#client-search-form');
   hiddenInput = $('#sv-community_post-category-ids');
   activeCategories = $('.sv-community__navigation li.active');
   postCategoryIds = activeCategories.map(function(){
     return $(this).attr('post-category-id');
   });

   hiddenInput.val(postCategoryIds.toArray());
   form.submit();
 });

});

function infinitescrollCommunityPosts(searchParams) {
  infScroll = $('#sv-posts-search-result');
  searchParams = searchParams || '';
  infScroll.infinitescroll({
    'navSelector': '.sv-community__posts-nav',
    'nextSelector': '.sv-community__posts-nav link[rel=next]',
    'itemSelector': '.sv-community__post-preview',
    'pathParse': function (path, nextPage) {
      return ['?page=', '&' + searchParams];
    }
  });
}
