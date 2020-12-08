window.FirmCityList = (($, undefined_) ->
  initFirmCityList = ->
    firmCitiesList = $('#firm-cities')
    firmCitiesList.sortable update: ->
      $.ajax
        url: firmCitiesList.data('url')
        type: "post"
        data: serializeFirmCities()

    serializeFirmCities = ->
      ids = $.makeArray(firmCitiesList.find('.sv-firm-city').map(->
        $(this).data "id"
      ))
      ids: ids

  init:  ->
    initFirmCityList()

)(jQuery)

$ ->
  FirmCityList.init()