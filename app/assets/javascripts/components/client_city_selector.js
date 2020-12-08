function CitySelector() {
  this.init();
}

CitySelector.prototype.init = function () {
  // Autocomplete CityId with Select2
  var city_selector = $('form').find('#client_city_id');
  if (city_selector.length > 0) {
    city_selector.removeClass('hidden');
    city_selector.parents('.cntrl-group').removeClass('hidden').find('label').removeClass('hidden');
    city_selector.select2({
      placeholder: 'Выберите город',
      minimumInputLength: 3,
      ajax: {
        url: city_selector.data('autocomplete-path'),
        dataType: 'json',
        data: function (term, page) {
          return {
            query: term,
            page: page
          };
        },
        results: function (data, page) {
          return {results: $.map(data, function(value, i) { return {id: value.id, text: value.full_name } }) };
        }
      },
      initSelection: function(element, callback) {
        var id = $(element).val();
        if (id !== '') {
          $.ajax(city_selector.data('autocomplete-path'), {
            data: {
              id: id
            }
          }).done(function(data) { callback({id: data.id, text: data.full_name }); });
        }
      }
    });
  }
};
