$ ->
  paymentValueInput = $("#payment_interkassa_deposit_value")
  courseBlock = paymentValueInput.parents('#payment_interkassa_deposit').find('.course')
  course = courseBlock.data 'course'

  paymentValueInput.keydown (e) ->
    if e.shiftKey or e.ctrlKey or e.altKey
      e.preventDefault()
    else
      n = e.keyCode
      e.preventDefault() unless (n is 8) or (n is 46) or (n >= 35 and n <= 40) or (n >= 48 and n <= 57) or (n >= 96 and n <= 105)
    return
  .bind 'input', ->
    updateAmount $(this)
  .focus()

  updateAmount = (e) ->
    val = e.val()
    if val > 0
      result = (val/course).toFixed(2)+' руб.'
      courseBlock.show()
    else
      courseBlock.hide()
      result = ''
    courseBlock.find('span.sum').text result

  updateAmount paymentValueInput