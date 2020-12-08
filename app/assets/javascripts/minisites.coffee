$ ->
  if $('.main-right-content').length > 0
    $(document).on "click", ".dropdown-menu-activate > a", ->
      $(this).toggleClass "active"
      $(this).next(".dropdown-menu-active").toggle()
      false
  if $('.map').length > 0
    new ymaps.Map $('.map')[0], {center:[0,0], zoom: 7}
