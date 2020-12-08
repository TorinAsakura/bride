$ ->
  adminSearchList = () ->
    format = (data) ->
      return data.text
    $("#firm_city_ids").select2({ minimumInputLength: 1 })

  window.adminSearchList = adminSearchList

  $(document).trigger 'services_updated'

  # -- find firms by substring in search field
  $("#sv-admin-search-field").keyup () ->
    if $(this).val().length > 2
      $(".sv-admin-search-list").find("div").hide()
      $("a:contains('" + $(this).val() + "')").parent().show()
    else
      $(".sv-admin-search-list").find("div").show()

  $('.best_in_place').best_in_place()
