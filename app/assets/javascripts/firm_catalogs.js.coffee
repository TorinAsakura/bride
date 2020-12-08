window.FirstFirmCatalogList = (($, undefined_) ->
  $itemsMsnrs = {}

  initItemsMasonry = (selector) ->
    selectorContainer = $(selector)
    if selectorContainer.length > 0
      itemsContainer = selectorContainer.find('#firm-catalog-items')
      if itemsContainer.length > 0
        $itemsMsnrs[selector] = new Masonry itemsContainer.get(0),
          itemSelector: '.item'
          gutter: 5

        itemsContainer.find('.item a').click (e) ->
          e.preventDefault()
          firmCatalog = $(this)
          id = firmCatalog.data 'id'
          name = firmCatalog.text()

          # Actions by select first firm sphere
          newSphereForm = $('form#new_sphere')
          if newSphereForm.length > 0
            newSphereForm.find('input#sphere_firm_catalog_id').val id
            newSphereForm.submit()

          # Actions by select register firm city
          registerSphereFields = $('input[name="user[firm_catalog_ids]"]')
          if registerSphereFields.length > 0
            registerSphereFields.each ->
              $(this).val(id).next().text name

            $.fancybox.close();
            $('[data-js=link-modal-register]').click() if selectorContainer.data 'modal'

  init: (selector) ->
    initItemsMasonry(selector)

  reload: (selectors) ->
    $.each selectors, (i, selector) ->
      if $(selector).length > 0
        $itemsMsnrs[selector].resize()

)(jQuery)

window.FirmCatalog = ((w, $, undefined_) ->

  activateSubmenu = (row) ->
    $row = $(row)
    submenuId = $row.data("submenuId")
    $submenu = $("#" + submenuId)
    height = $row.parent().outerHeight()
    width = $row.parent().outerWidth()

    # Show the submenu
    $submenu.css
      display: "block"
      top: -1
      left: width - 2 # main should overlay submenu
      height: height - 2*(1+10) # padding for main dropdown's arrow

    # Keep the currently activated row's highlighted look
    $row.addClass "maintainHover"
    return


  deactivateSubmenu = (row) ->
    $row = $(row)
    submenuId = $row.data("submenuId")
    $submenu = $("#" + submenuId)

    # Hide the submenu and remove the row's highlighted look
    $submenu.css "display", "none"
    $row.removeClass "maintainHover"
    return

  initCatalog = ( catalogs ) ->
    catalogs.menuAim
      activate: activateSubmenu
      deactivate: deactivateSubmenu
      exitMenu: resetSubmenu

  resetSubmenu = ( catalogs ) ->
    $(catalogs).find('.sub-catalog').hide();
    $(catalogs).find('.maintainHover').removeClass 'maintainHover'

  init: ( catalogs ) ->
    initCatalog $(catalogs)

  reset: ( catalogs ) ->
    resetSubmenu $(catalogs)

)(window, jQuery)

window.FirmCatalogCitySelect= ((w, $, undefined_) ->
  initListActions = ( cityList ) ->
    if cityList.length > 0
      cityList.find('#city-items .city-item a, #select-all').click (e) ->
        e.preventDefault()
        changeCity $(this)

  changeCity = (city) ->
    catalog = $('#sv-firm-catalogs')
    id = city.data 'id'
    citySelectLink = $('.sv-company-side-city-select a')
    linkName = (if 'all' is id then citySelectLink.data('all') else city.text())
    citySelectLink.find('span').text linkName

    activeCatalogLink = catalog.find('.children-category ul li.active a')
    activeCatalogLink = catalog.find('.sv-firm-catalog-item.active > a') if activeCatalogLink.length is 0

    urlMask = catalog.data 'url'

    catalog.find('.category-link').each ->
      that = $(this)
      link = urlMask.replace('/00/', '/'+id+'/').replace '/01/', '/'+that.data('catalog')+'/'
      that.attr 'href', link

    if activeCatalogLink.length > 0
      activeCatalogLink.click()
    else
      catalog.find('#new_firm_catalog a').click()

  init: ( cityList ) ->
    initListActions $(cityList)

)(window, jQuery)

$ ->
  FirmCatalog.init '#sv-firm-catalogs'
  FirmCatalogCitySelect.init '#side-city-select'
