window.MinisitesGuest = (($, undefined_) ->

  init = (type) ->
    lists = (if !!type then ['#' + type + '-guests'] else ['#groom-guests', '#bride-guests'])
    $.each lists, (i, elem) ->
      list = $(elem)
      newGuest = list.find('#guest_new')
      if newGuest.length > 0
        list.find('.remove-new-guest').click (e) ->
          e.preventDefault()
          newGuest.remove()
          list.parent().find('.add-item').show()
        true

  init: (type = undefined_) ->
    init type

)(jQuery)

$ ->
  MinisitesGuest.init()