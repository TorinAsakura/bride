$().ready(function() {
  $(document).on('click','#sv-admin-add-task li, #sv-admin-remove-task li', function(e){
    return $(this).find('.name a').trigger('click');
  });

  $(document).on("ajax:success", '#sv-admin-add-task li a',
    function(evt, data, status, xhr){
      linkObj = $('.task-id-' + xhr.responseJSON.task_id).find('a');
      href = linkObj.attr('href').replace('add_task','remove_task');
      linkObj.attr('href', href);
      $('.task-id-' + xhr.responseJSON.task_id).appendTo('#sv-admin-remove-task .sv-admin-plans__tasks-list');
      $('#sv-admin-remove-task .link-filter-tasks').click();
      ajaxChangeTaskPosition();
  });

  $(document).on("ajax:success", '#sv-admin-remove-task li a', function(evt, data, status, xhr){
      linkObj = $('.task-id-' + xhr.responseJSON.task_id).find('a');
      href = linkObj.attr('href').replace('remove_task','add_task');
      linkObj.attr('href', href);
      $('.task-id-' + xhr.responseJSON.task_id).appendTo('#sv-admin-add-task .sv-admin-plans__tasks-list');
      $('#sv-admin-add-task .link-filter-tasks').click();
      ajaxChangeTaskPosition();
  });

  $(document).on('click','.link-filter-tasks', function(e){
    e.preventDefault();
    input = $(this).parent().find('.sv-admin-plan__find-task-input');
    select = $(this).parent().find('.sv-admin-plan__task-select-filter.select2-offscreen');
    list = $(this).parents('.sv-admin-plans__tasks');
    taskFilterList(input, list);
    taskCategoryFilterList(input, select, list)
  });
});

function taskFilterList(input, list) {
  var filter = input.val();
  if(filter){
    $matches = $(list).find('a:Contains(' + filter + ')').parents('.sv-admin-plans__task-box');
    $('.sv-admin-plans__task-box', list).not($matches).hide();
    $matches.show();
  }else{
    $(list).find('.sv-admin-plans__task-box').show();
  }
}

function taskCategoryFilterList(input, select, list) {
  var class_filter = '.task-category-id-' + select.val();
  var filter = input.val();
  if(select.val()){
    $matches = $(list).find(class_filter);
    $('.sv-admin-plans__task-box', list).not($matches).hide();
    if (!filter){
      $matches.show();
    }
  }
}

function scrollPlans(){
  $(".sv-plan-dates").mCustomScrollbar({
    horizontalScroll:true,
    theme:'svadba'
  });
}

//сортировка тасков
function adminTaskChangePosition(){
  list = $('#sv-admin-remove-task .sv-admin-plans__tasks-list');
  list.sortable({
    update: function() { ajaxChangeTaskPosition() }
  });
}

function ajaxChangeTaskPosition(){
  list = $('#sv-admin-remove-task .sv-admin-plans__tasks-list');
  $.ajax({
    url: list.data('url'),
    type: 'post',
    data: serilizeIds(list)
  });
}
