$ ->
  $('.city-firm-fields').find('.sv-firm-addresses.sorted').each ->
    $that = $(this)
    $that.sortable update: ->
      $.ajax
        url: $that.data('url')
        type: "post"
        data: serialize()

    serialize = ->
      ids = $.makeArray($that.find(".sv-firm-address").map(->
        $(this).data "itemId"
      ))
      ids: ids

  return