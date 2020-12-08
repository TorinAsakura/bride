$(document).on 'click', '.main-right-content .show-all > a', ()->
  $(this).closest('article').find(".#{$(this).data('target')} .hide").removeClass('hide')
  $(this).hide()
  false
