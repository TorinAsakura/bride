$ ->
  photos = $('#photos')
  photos.infinitescroll
    navSelector: '#photos-nav'
    nextSelector: '#photos-nav link[rel=next]'
    itemSelector: '.photo'
    loading:
      finishedMsg: photos.data('finish')
      msgText: photos.data('load')

  $('#show-all-albums').click (e) ->
    e.preventDefault()
    $('#albums').find('.album.hidden').removeClass 'hidden'
    $(this).addClass 'hidden'
  false