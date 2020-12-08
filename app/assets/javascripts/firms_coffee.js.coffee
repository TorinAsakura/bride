window.FirmCityForm = (($, undefined_) ->
  initFirmCityForm = ->
    citiesSelector = $('#change-first-city')
    if citiesSelector.length > 0
      itemsBlock = citiesSelector.find('#city-items')
      itemsBlock.find('.city-item a').click (e) ->
        city = $(this)
        e.preventDefault()

        id = city.data 'id'
        fullName = city.attr 'title'

        # Actions by select first firm city
        firstCityBlock = $('[data-js=city-firm-select-wrapper]')
        if firstCityBlock.length > 0
          changeLink = firstCityBlock.find('.sv-city-firm-select-wrapper__input a')
          changeLink.text fullName
          changeUrl = changeLink.data 'url'

          $.ajax
            type: "PUT"
            url: changeUrl
            data:
              city_firm:
                city_id: id

          addressForm = $(".sv-firm-cities-address").find("form")
          addressForm.find("input#city_firm_city_id").val id
          addressForm.find("h4").text fullName

          $.fancybox.close();

        # Actions by Change first firm city
        newCityForm = $('form#new_city_firm')
        if newCityForm.length > 0
          newCityForm.find('input#city_firm_city_id').val id
          newCityForm.submit()

        # Actions by select register firm city
        registerCityFirmFields = $('input[name="user[city_ids]"]')
        if registerCityFirmFields.length > 0
          registerCityFirmFields.each ->
            $(this).val(id).next().text fullName

          $.fancybox.close();
          $('[data-js=link-modal-register]').click() if citiesSelector.data 'modal'

        itemsBlock.find('.city-item').removeClass 'hidden'
        city.parents('.city-item').addClass 'hidden'

  init:  ->
    initFirmCityForm()

)(jQuery)

window.NotificationByFields =  (($, undefined_) ->
  notificationByFieldsInit = (fields) ->
    fields.each ->
      fieldBlock = $(this)
      notification = fieldBlock.find('.notification')

      fieldBlock.find('input').focus ->
        notification.addClass "visible"
      .blur ->
        notification.removeClass "visible"

  init: (fields) ->
    notificationByFieldsInit fields

)(jQuery)

window.updateFirmServices = (($, undefined_) ->
  servicesForm = undefined_
  firmServicesList = undefined_

  initFirmServiceRemoveLinks = (elms) ->
    elms.on 'click', (e) ->
      e.preventDefault()
      form = $(this).closest('.sv-firm-services-line')
      form.remove()
      deleteUrl = form.data 'url'
      if deleteUrl
        $.ajax(
          url: deleteUrl
          type: "DELETE"
        )

  init = ->
    servicesForm = $('[data-js=firm-services-form]')
    firmServicesList = servicesForm.find('#firm-services-lines')

    initFirmServiceRemoveLinks servicesForm.find('[data-js=firm-service-remove]')
    firmServicesList.sortable update: ->
      if firmServicesList.find('.sv-firm-services-line-new').length > 0
        servicesForm.submit()
      else
        updateFirmServicesPositions()

  updateFirmServicesPositions = ->
    $.ajax
      url: firmServicesList.data('url')
      type: "post"
      data: serializeFirmServices()
    firmServicesList.find('.sv-firm-services-line').removeClass 'last'
    firmServicesList.find('.sv-firm-services-line:last').addClass 'last'

  serializeFirmServices = ->
    ids = $.makeArray(firmServicesList.find('.sv-firm-services-line:not(".sv-firm-services-line-new")').map(->
      $(this).data "id"
    ))
    ids: ids

  save = ->
    $('.sv-firm-services-save').on 'click', (e) ->
      e.preventDefault()
      servicesForm.submit()

  init: ->
    init()
    save()

  remove: (elms)->
    initFirmServiceRemoveLinks elms


)(jQuery)

$ ->
  $("#firm_firm_catalog_ids").select2()
  $("#firm_firm_catalogs_name").select2()
  $("#firm_base_sphere_id").select2()

  $('select[name^="firm[firm_catalogs_attributes]"]').select2()
  $('select[name^="firm[spheres_attributes]"]').select2()
  $('select[name^="firm[city_firms_attributes]"]').select2()

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).next().find('input[type=hidden]').val('true')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  updateFirmServices.init()

  # Field Notifications
  NotificationByFields.init $('.field-block.with-notification')

  $(document).on "change", '[name="address[base]"]', (event) ->
    if $(this).val() == "true"
      $("#extended_params").show()
    else
      $("#extended_params").hide()

  (->
    updateFirmPagesOrderButtons = ->
      $('[data-js=firm-page-switcher]').unbind('click').on 'click', (e) ->
        firmPage = $(this).closest('[data-js=firm-page-line]')
        $.ajax
          url: "/firms/#{$("#firm_id").val()}/firm_pages/#{firmPage.data('id')}/switch"
          type: 'POST'
          dataType: 'script'

      firmPagesList = $('#firm-pages-list')
      firmPagesList.sortable update: ->
        $.ajax
          url: firmPagesList.data('url')
          type: "post"
          data: serializeFirmPages()

      serializeFirmPages = ->
        ids = $.makeArray(firmPagesList.find('li.firm-page').map(->
          $(this).data "id"
        ))
        ids: ids

    $(document).on 'firm_pages_updated', updateFirmPagesOrderButtons
    $(document).trigger 'firm_pages_updated'
  )()

  $('.sv-firm-remove-account-popup').hide()
  $('.sv-firm-remove-account-link').on 'click', (e) ->
    e.preventDefault()
    $('.sv-firm-remove-account-popup').show()

  $('[data-js=firm-change-status-link]').on 'click', (e) ->
    e.preventDefault()
    $('.firm-control-panel-link.adding-services').trigger('click')

  $('[data-js=firm-remove-client]').on 'click', (e) ->
    e.preventDefault()

  # popups for address' modal
  $('[data-js=firm-address-address]').on 'focus', ->
    $('.sv-firm-address-address-popup').show()

  $('[data-js=firm-address-address]').on 'blur', ->
    $('.sv-firm-address-address-popup').hide()

  $('[data-js=new-address-link]').on 'click', ->
    window.cityFirmForm = $(this).closest('form')
    
  # clients search form
  resetGender = ->
    $('.sv-firm-clients-search-gender').removeClass('active')
  
  $('[data-js=clients-search-all]').unbind('click').on 'click', (e) ->
    e.preventDefault()
    resetGender()
    $(this).addClass('active')
    genderField = $(this).closest('form').find('[data-js=gender-field]')
    genderField.empty()

  $('[data-js=clients-search-male]').unbind('click').on 'click', (e) ->
    e.preventDefault()
    resetGender()
    $(this).addClass('active')
    genderField = $(this).closest('form').find('[data-js=gender-field]')
    genderField.val('t')

  $('[data-js=clients-search-female]').unbind('click').on 'click', (e) ->
    e.preventDefault()
    resetGender()
    $(this).addClass('active')
    genderField = $(this).closest('form').find('[data-js=gender-field]')
    genderField.val('f')

  $(".vd-blacklist input[type='radio'][class= 'radio-style-circle']").on 'change', () ->
    $(this).closest('.vd-blacklist').find('.all-bklist').hide()
    if $(this).val() == 'all'
      $(this).closest('.vd-blacklist').find('.all-bklist').show()
    else
      $(".#{$(this).val()}").show()

  FirmCityForm.init();
