# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#page_content').redactor
    lang:         'ru'

  colorPicker = $('.form-colorpicker')

  if colorPicker.length > 0
    $("input", colorPicker).ColorPicker(
      onChange: (hsb, hex, rgb, el) ->
        hex = '#' + hex
        $(".site-color", colorPicker).val(hex)
        $('.fc-frame', colorPicker).css('backgroundColor', hex)).on 'keyup', ()->
          $(this).ColorPickerSetColor(this.value)
          $('.fc-frame', colorPicker).css('backgroundColor', this.value)

    $(".reset", colorPicker).on 'click', ()->
      $("input", colorPicker).val('')
      $('.fc-frame', colorPicker).css('backgroundColor', '#fff')
      false