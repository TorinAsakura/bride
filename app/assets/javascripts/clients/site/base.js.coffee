$ ->
  bodyImage = $('body').data('bg')
  if !!bodyImage
    $.vegas(src: bodyImage) "overlay"

  window.commentForm = new CommentForm(
    element: "#wall"
    modal: false
    multipart: true
  )