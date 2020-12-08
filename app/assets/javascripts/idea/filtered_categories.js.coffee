$ ->
  ideaCategories = $('#idea-categories')
  if ideaCategories.length > 0
    ideaCategories.multipleFilterMasonry
      itemSelector: '.idea-category'
      filtersGroupSelector: '#sections-filter'

    ideaCategories.masonry "on", "layoutComplete", ->
      IdeaHoverBg.init()

    $('#all-categories').click (e) ->
      e.preventDefault()
      $('#sections-filter').find('input[type=checkbox]').each ->
        if $(this).is(':checked')
          $(this).parent('label').click()