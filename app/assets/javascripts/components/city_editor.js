function CityEditor(element, options) {
  this.$element = element;
  this.$element.wrap('<div class="city-editor"></div>')
    .wrap('<div class="value"></div>')
    .after('<i class="icon-edit"></i>')
    .filter("i");



  this.wrapper = this.$element.closest('.city-editor');
  this.wrapper.append('<div class="editor hide input-append">' +
    '<input type="text" class="span3 city-selector"/>' +
    '<button class="add-on ok"><i class="icon-ok"></i></button>' +
    '<button class="add-on cancel"><i class="icon-remove"></i></button>' +
    '</div>');

  $('input', this.wrapper).typeahead({
    "source": $.proxy(this.cities, this),
    "updater": this.updater,
    "highlighter": this.highlighter,
    "matcher": this.matcher,
    "sorter": this.sorter
  });

  var typeahead = $('input', this.wrapper).data('typeahead');
  typeahead.process = this.process;
  typeahead.render = this.render;

  $('.value i', this.wrapper).click($.proxy(this.show, this));
  $('button.ok', this.wrapper).on('click', $.proxy(this.update, this));
  $('button.cancel', this.wrapper).on('click', $.proxy(this.hide, this));
}

CityEditor.prototype = {
  constructor: CityEditor,

  show: function() {
    $('.value', this.wrapper).addClass('hide');
    $('.editor', this.wrapper).removeClass('hide');
    $('input', this.wrapper).val(this.$element.html());
  },

  hide: function(e) {
    if (e)
      e.preventDefault();
    $('.editor', this.wrapper).addClass('hide');
    $('.value', this.wrapper).removeClass('hide');
  },

  cities: function(query, callback) {
    $.ajax({
      "dataType": 'json',
      "success": function(data) { callback(data) },
      "data": {"query": query},
      "url": this.$element.data('autocomplete-path')
    });
  },

  update: function(e) {
    e.preventDefault();
    $.ajax({
      "dataType": 'json',
      "success": $.proxy(this.updated, this),
      "error": $.proxy(this.error, this),
      "url": this.$element.data('update-path'),
      "data": {"city_id": $('input', this.wrapper).data('id') },
      "method": "post"
    });
  },

  updated: function() {
    this.$element.html($('input', this.wrapper).val());
    this.hide();
  },

  error: function() {
    alert('Не удалось сохранить значение. Попробуйте повторить попытку позже.');
    this.hide();
  },

  updater: function(item) {
    this.$element.attr('data-id', this.$menu.find('.active').attr('data-id'));
    var id = this.$menu.find('.active').attr('data-id');
    return item;
  },

  highlighter: function(item) {
    var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    return item.full_name.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
      return '<strong>' + match + '</strong>'
    })

  },

  matcher: function(item) {
    return true;
  },

  sorter: function(items) {
    var beginswith = []
      , caseSensitive = []
      , caseInsensitive = []
      , item

    while (item = items.shift()) {
      if (!item.full_name.toLowerCase().indexOf(this.query.toLowerCase())) beginswith.push(item)
      else if (~item.full_name.indexOf(this.query)) caseSensitive.push(item)
      else caseInsensitive.push(item)
    }

    return beginswith.concat(caseSensitive, caseInsensitive)
  },

  render: function (items) {
    var that = this

    items = $(items).map(function (i, item) {
      i = $(that.options.item).attr('data-value', item.full_name).attr('data-id', item.id)
      i.find('a').html(that.highlighter(item))
      return i[0]
    })

    items.first().addClass('active')
    this.$menu.html(items)
    return this
  },

  process: function (items) {
    var that = this

    items = $.grep(items, function (item) {
      return that.matcher(item.full_name)
    })

    items = this.sorter(items)

    if (!items.length) {
      return this.shown ? this.hide() : this
    }

    return this.render(items.slice(0, this.options.items)).show()
  }
};
