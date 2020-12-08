$ ->
  $("#colored-tag-color").minicolors()

  searchTags = ()->
    $(".tag_input").each ->
      $(this).combosex
        delay: 222 # задержка от спама
        tags: true
        append: true # разрешаем добавлять произвольные значения
        tagsDel: ','
        type: 'input'
        railsName: this.name

        suggest: (hash, ex) ->

          # if (this.xhr) this.xhr.abort(); /* Для локальных xhr запросов
          @xhr = $.getJSON("http://suggest.yandex.ru/suggest-ya.cgi?callback=?",
            lr: 213
            v: 3
            part: ex.str
          , (data) ->
            res = []
            for i of data[1]
              unless data[1][i][0] is "nav"
                res.push # Формируем результат из любого формата в формат плагина
                  val: data[1][i]
                  text: data[1][i]

            ex.results res # этим методом возвращаются результаты поиска для отображения в дальнешем
          )

  window.searchTags = searchTags

$(document).on 'click', "a.destroy-tag", (e)->
  $(this).parent().hide()
