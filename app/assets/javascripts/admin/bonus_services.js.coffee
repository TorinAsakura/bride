$ ->
  if $('[data-js=subscription-service-form]').length > 0
    $('[data-js=subscription-service-description]').redactor({lang: 'ru'})

  $('#sub-list').sortable update: ->
    $.ajax
      url: $('#sub-list').data('url')
      type: "post"
      data: serialize()

  serialize = ->
    ids = $.makeArray($("#sub-list .subscription-service").map(->
      $(this).data "id"
    ))
    ids: ids

  return