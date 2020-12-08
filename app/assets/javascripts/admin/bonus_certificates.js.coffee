$ ->
  if $('[data-js=bonus-certificate-form]').length > 0
    $('[data-js=bonus-certificate-description]').redactor({lang: 'ru'})

  return