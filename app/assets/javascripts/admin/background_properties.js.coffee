$ ->
  if $('[data-js=background-property-form]').length > 0
    tag = $((if $('[data-js=header]').is(':checked') then 'header' else 'body'))

    if $('[data-js=header]').is(':checked')
      $('.header-colors-field').removeClass('hidden');

    setBG = (arg, val) ->
      $(tag).css 'background-'+arg, val

    setBGImage = (image)->
      $(tag).css
        'background-image': 'url(' + image + ')'

    # on init page set background color
    init = ->
      setBG 'color', $('[data-js=background-property-color]').val()

      image = $('.preview_img').find('img')
      if image.length > 0
        setBGImage image.attr 'src'

      $('[type=radio]').trigger 'change'


    $.each [
      'attachment'
      'position'
      'repeat'
    ], (i, radio) ->
      $("[name='background_property["+radio+"]']").change ->
        topPos = (if radio is 'position' then 'top' else '')
        setBG radio, $(this).val()+topPos if $(this).is(':checked')

    $('[data-js=header]').change ->
      $('.header-colors-field').toggleClass('hidden');
      $(tag).css 'background', 'transparent'
      tag = $(if $('[data-js=header]').is(':checked') then 'header' else 'body')
      init()


    $("#background_property_image").change ->
      if this.files and this.files[0]
        file = this.files[0]
        reader = new FileReader()
        reader.onload = (e) ->
          img = new Image()
          img.onload = ->
            setBGImage(e.target.result)
            $('.preview_img').empty()
            $('.preview_img').append img
          img.src = e.target.result
        reader.readAsDataURL file

    $('[data-js=background-property-color]').minicolors
      position: 'top right'
      letterCase: 'uppercase'
      defaultValue: '#FFFFFF'
      control: 'wheel'
      change: (hex)->
        setBG 'color', hex

    $('.header-colors-field').find('input').each ->
      v = $(this).val()
      $(this).minicolors
        position: 'top right'
        letterCase: 'uppercase'
        defaultValue: v || '#FFFFFF'
        control: 'wheel'

    $('[data-js=background-property-reset-color]').click ->
      resetBGColor()

    resetBGColor = () ->
      resetColor = '#FFFFFF'
      $('[data-js=background-property-color]').val resetColor
      $('.minicolors-swatch').find('span').css
        'background-color': resetColor
      setBG 'color', resetColor

    init()
