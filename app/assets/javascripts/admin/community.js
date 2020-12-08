$(function () {
  $("#community_question_category_ids").select2();


  $(document).on('click','[data-js=community__add-moderator]', function(e){
    email = $("#moderator_email").val();
    $.ajax({
      type: "POST",
      url: this.href,
      data: "email="+email,
      success: function(data){
        $('#moderator_email').val('');
      }
    });
    return false;
  });
  
  $(document).on('click','[data-js=community__add-post-category]', function(e){
    name = $("#post_category_name").val();
    $.ajax({
      type: "POST",
      url: this.href,
      data: "name="+name,
      success: function(data){
        $('#post_category_name').val('');
      }
    });
    return false;
  });


  $(document).on('click','[data-js=community-remove-logo]', function(e){
    $('#sv-admin-community__logo').hide();
  });

  communityCategoriesList = $('#sv-admin-community-categories__list');
  communityCategoriesList.sortable({
    update: function() { 
      $.ajax({
        url: communityCategoriesList.data('url'),
        type: 'PUT',
        data: serilizeIds(communityCategoriesList)
      });    
     }
  });
})

function orderCommunities() {
  communitiesList = $('#sv-admin-communities__list');
  communitiesList.sortable({
    update: function() { 
      $.ajax({
        url: communitiesList.data('url'),
        type: 'PUT',
        data: serilizeIds(communitiesList)
      });    
     }
  });
}
