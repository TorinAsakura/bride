$ ->
  notify_open = false
  notification=
    delete: $(".sv-end-form a[data-method=\"delete\"]").parent().find(".notification")
    phone: $('#client-phone .field-block .notification')




  $(".sv-end-form a[data-method=\"delete\"]").click ->
    notification.delete.show()
    false
  $(document).click (event)->
    unless $(event.target).closest(".notification").length
      notification.delete.hide()

  $(document).on "click", "#client-phone input", ->
    $("#client-phone span.result.updated").hide()
    $("#client-phone .field-block .notification").show()
    $("#client-phone [type=submit]").show()

  $('#client-phone .field-block .notification .link-style.sv-l').click ->
    $(this).closest(".cntrls").find("[type=submit]").click()

  $('.link-style', notification.delete).click ->
    $(".sv-end-form a[data-method=\"delete\"]").unbind('click')
    $(".sv-end-form a[data-method=\"delete\"]").click()

