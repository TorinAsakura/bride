# ===== Menu ===== 
$("#menu-open").on "click", ->
  $(this).toggleClass "show hidden"
  $("#menu-dummy").toggleClass "show hidden"
  $(".menu ul li").toggleClass "hidden show animated bounceInRight"
  setTimeout (->
    $("#menu-close").toggleClass "show hidden"
    $("#menu-dummy").toggleClass "show hidden"
    return
  ), 2500
  false

$("#menu-close").on "click", ->
  $(this).toggleClass "show hidden"
  $("#menu-dummy").toggleClass "show hidden"
  $(".menu ul li").toggleClass "bounceInRight bounceOutRight"
  setTimeout (->
    $("#menu-open").toggleClass "show hidden"
    $("#menu-dummy").toggleClass "show hidden"
    $(".menu ul li").removeClass "animated bounceOutRight"
    $(".menu ul li").toggleClass "show hidden"
    return
  ), 2500
  false