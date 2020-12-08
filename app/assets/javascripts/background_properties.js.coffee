$ ->
  $(".select-background-image").click ->
    getBgImagesList = (url) ->
      listBlock = $(modalBlock).find("#images-list")
      $(listBlock).addClass("loading").html ""
      $.getJSON(url, {}).done (data) ->
        if "ok" is data.status
          $(listBlock).removeClass("loading").html data.html.list
          initCheck()
          if data.html.pages.total > 1
            paginate = ""
            prevPage = "<a class=\"prev-page link-style\" href=\"#\"><i class=\"icon-angle-left\"></i></a>"
            nextPage = "<a class=\"next-page link-style\" href=\"#\"><i class=\"icon-angle-right\"></i></a>"
            prev = data.html.pages.prev
            next = data.html.pages.next
            paginate = paginate + prevPage  if prev
            paginate = paginate + nextPage  if next
            info = "<span class=\"info\">Страница " + data.html.pages.current + " из " + data.html.pages.total + "</span>"
            paginate = paginate + info
            $(modalBlock).find("#images-paginate").html paginate
            if prev
              $(modalBlock).find(".prev-page").click ->
                getBgImagesList baseUrl + "?page=" + prev
                return

            if next
              $(modalBlock).find(".next-page").click ->
                getBgImagesList baseUrl + "?page=" + next
                return

        return

      return
    initCheck = ->
      selectImageBtn = $(modalBlock).find("#select-image")
      $(selectImageBtn).addClass("hidden").removeData [
        "tag"
        "style"
        "id"
      ]
      $(modalBlock).find(".background_property").click ->
        checkBlock = $(this).find(".check")
        checkData = $(checkBlock).data()
        $(modalBlock).find(".check").removeClass "checked"
        $(checkBlock).addClass "checked"
        $(selectImageBtn).removeClass "hidden"
        $(selectImageBtn).data("tag", checkData.tag).data("style", checkData.style).data "id", checkData.id
        return

      return

    template = "<div class='modal bg-images-modal'>" + "<div class='modal-header'><h4 class='title_nobg'>" + $(this).data("title") + "</h4></div>" + "<div class='modal-body'>" + "<p>" + $(this).data("text") + "</p>" + "<div id='images-paginate'></div>" + "<div id='images-list' class='loading'></div>" + "</div>" + "<div class='modal-footer'><a href='#' class='btn hidden' id='select-image' data-input='" + $(this).data("input") + "'>Выбрать изображение</a></div>" + "</div>"
    modal = new ModalViewer(window.location, window.location, template)
    modal.show()
    modalBlock = $(".bg-images-modal")
    baseUrl = $(this).data("url")
    getBgImagesList baseUrl

    $(modalBlock).find("#select-image").click ->
      data = $(this).data()
      form = $(".background-form")
      input = $(form).find(data.input)
      input.val data.id
      preview = input.parents(".form-inline").find(".preview-background")
      $(preview).removeClass("hidden").data("tag", data.tag).data "style", data.style
      $.fancybox.close()
      false

    false

  $(".preview-background").click ->
    data = $(this).data()
    $(data.tag).attr "style", data.style
    false
