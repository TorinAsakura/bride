window.IdeaHoverBg = (($, undefined_) ->
  initHoverBG = ->
    ideaBgImages = {}
    $('.sv-idea__image-body').each ->
      that = $(this)
      active = that.data 'active'
      id = that.data 'id'
      ideaBgImages[id] = {}

      bgImg = new Image()
      bgImg.onload = ->
        ideaBgImages[id]['bg'] = bgImg
        grayBgImg  = new Image()
        grayBgImg.onload = ->
          ideaBgImages[id]['grayBg'] = grayBgImg
          currentImg = (if active then bgImg.src else grayBgImg.src)
          that.css("background-size", "cover")
          that.css("background-image", "url(\"" + currentImg + "\")")

          that.parents('.sv-idea').hover (->
            unless active
              hoverImg = ideaBgImages[$(this).find('.sv-idea__image-body').data('id')]['bg'].src
              $(this).find('.sv-idea__image-body').css "background-image": "url(\"" + hoverImg + "\")"
          ), ->
            unless active
              greyImg = ideaBgImages[$(this).find('.sv-idea__image-body').data('id')]['grayBg'].src
              $(this).find('.sv-idea__image-body').css "background-image": "url(\"" + greyImg + "\")"

        grayBgImg.src = that.data('grayBg')

      bgImg.src = that.data('bg')

  init: ->
    initHoverBG()
)(jQuery)

$ ->
  IdeaHoverBg.init()
