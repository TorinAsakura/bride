$(function(){
  $(document).on('click', '#sv-timetable__setting .sv-a-back', function(e){
      $('#sv-timetable__events-menu li').first().addClass('active');
  });

  $(document).on('click', '#sv-event__sidebar .sv-title-edit', function(e){
      $('#sv-timetable__events-menu li.active').removeClass('active');
  });

  $(document).on('click', '[data-js=scheduler-event-destroy]', function(e){
    e.preventDefault();
    var eventId = $(this).data('id');
    $.ajax({
      url: $(this).attr('href'),
      type: 'DELETE',
      data: {},
      success: function(resp) {
        if (resp.status == 'ok') {
          $('#e-remove-' + eventId).remove();
          $('#e-status-' + eventId).remove();
          $('#e-open-' + eventId).remove();
        }
      }
    });
  });

  $('.sv-select-city .city-item, .sv-select-city #select-all').click(function(e){
    e.preventDefault();
    cityId = $(this).children('a').data('id');
    $('#search_city_id').val(cityId);
    $.fancybox.close();
  });

  $(document).on('change', '.sv-event__input-checkbox', function(){
    input = $(this)
    status = (input.is(':checked')) ? 1  : 0
    $.ajax({
      url: window.location.href + '/subevents/' + input.val() + '/status/' + status,
      type: 'PUT'
    });
  });

  $('#sv-timetable__events-menu li .name').click(function(event){
    liParent = $(this).parents('li');
    if (!liParent.hasClass('active')){
      $('#sv-timetable__events-menu li.active').removeClass('active');
      liParent.addClass('active');
    }
  });

  // checked action
  $('[data-js=scheduler-event-checked]').change(function(){
    checkbox = $(this);
    liParent = checkbox.parents('li');
    liParent.toggleClass('checked');
    liParent.find('.sv-event__hide').toggleClass('hidden');
    status = (liParent.hasClass('checked')) ? 'complete' : 'uncomplete';
    eventChangeVisibilityAjax(checkbox.children('input').val(), status);
    return false;
  });

  //hide action
  $('[data-js=scheduler-event-hide]').click(function(){
    checkbox = $(this);
    liParent = checkbox.parents('li');
    liParent.toggleClass('checked');
    liParent.find('.sv-event__active, .sv-event__unhide, .sv-event__hide').toggleClass('hidden');
    eventChangeVisibilityAjax(checkbox.children('input').val(), 'hide');
    return false;
  });

  //unhide action
  $('[data-js=scheduler-event-unhide]').click(function(){
    unhidCheckbox = $(this);
    liParent = unhidCheckbox.parents('li');
    liParent.toggleClass('checked');
    liParent.find('.sv-event__active, .sv-event__unhide, .sv-event__hide').toggleClass('hidden');
    eventChangeVisibilityAjax(unhidCheckbox.children('input').val(), 'unhide');
    return false;
  });

  //slide infobox
  $('#slide-info-box').click(function(){
    if ($('.sv-prezent').is(':visible')) {
      $('.sv-prezent').slideUp();
      $.cookie('sv-scheduler-info-box', 'slideUp', { path: '/' });
    }
    else {
      $('.sv-prezent').slideDown();
      $.removeCookie('sv-scheduler-info-box', { path: '/' });
    }
    $('#slide-info-box').toggleClass('sv-title-up').toggleClass('sv-title-down');
    return false;
  });
});

function eventChangeVisibilityAjax(event_id, status){
  $.ajax({
    url: '/wedding/timetables/0/events/' + event_id + '/change_status',
    type: 'PUT',
    data: { 'status': status }
  });
}

function clearEventContent(){
  $('#sv-timetable__setting, #sv-show-ideas, #sv-read-it, #sv-view-it').html('');
  $('#sv-event__firms').hide();
}
