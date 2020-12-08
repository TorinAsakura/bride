window.WeddingCitiesList =  (($, undefined_) ->
  $itemsMsnrs = {}

  initItemsMasonry = (selector) ->
    selectorContainer = $(selector)
    if selectorContainer.length > 0
      itemsContainer = selectorContainer.find('#city-items')
      if itemsContainer.length > 0
        countries = selectorContainer.find('.sv-city-countries').find('.country-index')
        itemsIndexes = selectorContainer.find('.sv-city-indexes')
        activeItems = []

        $itemsMsnrs[selector] = msnr = new Masonry itemsContainer.get(0),
          itemSelector: '.item'
          gutter: 5

        countries.each ->
          country = $(this)
          country.click ->
            active = $(this).hasClass 'active'
            unless active
              countries.removeClass 'active'
              $(this).addClass 'active'
              itemsContainer.find('.city-item').removeClass 'hidden'
              id = $(this).data 'id'
              if 0 isnt id
                itemsContainer.find('.city-item').each ->
                  if $(this).data('country') isnt id
                    $(this).addClass 'hidden'

              itemsContainer.find('.city-group').each ->
                if 0 is $(this).find('.city-item:not(.hidden)').length
                  $(this).addClass 'hidden'
                else
                  $(this).removeClass 'hidden'

              msnr.layout()

        itemsIndexes.find('.city-index').each ->
          index = $(this)
          index.click ->
            active = $(this).hasClass 'active'
            id = $(this).data 'id'
            if active
              $(this).removeClass 'active'
              activeItems.splice(activeItems.indexOf(id), 1);
            else
              $(this).addClass 'active'
              activeItems.push id

            reloadMasonry activeItems

        reloadMasonry = (ids) ->
          allItems = itemsContainer.find('.city-group')
          if ids.length > 0
            allItems.addClass 'hidden'
            $.each ids, (i, id) ->
              item = itemsContainer.find(".city-group[data-item='"+id+"']")
              if item.find('.city-item:not(.hidden)').length isnt 0
                item.removeClass 'hidden'
          else
            allItems.removeClass 'hidden'
          msnr.layout()

  reload: (selectors) ->
    $.each selectors, (i, selector) ->
      if $(selector).length > 0
        $itemsMsnrs[selector].resize()

  init: (selector) ->
    initItemsMasonry(selector)

)(jQuery)