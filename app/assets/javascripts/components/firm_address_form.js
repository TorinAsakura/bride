function FirmAddressForm(cityForm, html) {
  this.$cityForm = $(cityForm);
  this.html = html;
}

FirmAddressForm.prototype.show = function () {
  var that = this,
      $edit = $('#edit');

  $edit.html(this.html);

  $.fancybox.open($edit, {
    'fitToView': false,
    'scrolling': 'no',
    'closeBtn': false,
    'padding': 0,
    'beforeShow': function () {
      that.beforeShow();
    }
  });
};

FirmAddressForm.prototype.beforeShow = function () {
  var that = this;

  $('[data-js=firm-address-time-start]').clockpicker({autoclose: true});
  $('[data-js=firm-address-time-end]').clockpicker({autoclose: true});

  $('[data-js=firm-address-submit]').on('click', function(e) {
    e.preventDefault();

    that.saveParams($(this).closest('form'));
  });

  $('[data-js=firm-address-cancel]').on('click', function(e) {
    e.preventDefault();

    $.fancybox.close();
  });

  $('[data-js=firm-address-address]').on('focus', function() {
    $('.sv-firm-address-address-popup').show();
  }).on('blur', function() {
    $('.sv-firm-address-address-popup').hide();
  });

  $('[data-js=firm-address-explanation]').on('focus', function() {
    $('.sv-firm-address-explanation-popup').show();
  }).on('blur', function() {
    $('.sv-firm-address-explanation-popup').hide();
  });

  initAddFieldsLink();
};

FirmAddressForm.prototype.saveParams = function(addressForm) {
  var $addressForm = $(addressForm),
      $address,
      $coordinates,
      $field,
      name = $addressForm.find('#address_name').val(),
      address = $addressForm.find('#address_address').val(),
      explanation = $addressForm.find('#address_explanation').val(),
      i,
      id,
      that,
      city,
      fields,
      phones,
      phoneId;

  if (name && address && explanation) {
    id = new Date().getTime();
    city = this.$cityForm.find('[data-js=firm-city-name]').val();
    that = this;

    fields = [
      { 'input': $field, 'name': 'name', 'value': name },
      { 'input': $address, 'name': 'address', 'value': address },
      { 'input': $field, 'name': 'explanation', 'value': explanation },
      { 'input': $coordinates, 'name': 'coordinates', 'value': 'f' }
    ];

    for (i = 1; i < 5; ++i) {
      fields.push({
        'input': $field,
        'name':'working_time_start(' + i + 'i)',
        'value': $addressForm.find('#address_working_time_start_' + i + 'i').val() });
      fields.push({
        'input': $field,
        'name':'working_time_end(' + i + 'i)',
        'value': $addressForm.find('#address_working_time_end_' + i + 'i').val() })
    }

    $.each(fields, function(index, field) {
      field.input = $('<input/>')
        .attr('type', 'hidden')
        .attr('name', 'city_firm[addresses_attributes][' + id + '][' + field.name + ']')
        .val(field.value);
      that.$cityForm.append(field.input);
    });

    phones = '';
    $addressForm.find('[data-js=address-phone-field]').each(function(index, field) {
      if ($(field).val()) {
        phoneId = Math.ceil(Math.random() * 100000);
        $field = $('<input/>')
          .attr('type', 'hidden')
          .attr('name', 'city_firm[addresses_attributes][' + id + '][phone_numbers_attributes][' + phoneId + '][phone]')
          .val($(field).val());
        phones += (phones.length > 0) ? $field.val() : (', ' + $field.val());
        that.$cityForm.append($field);
      }
    });

    $.fancybox.close();

    addMarkerToMap({
      'id': this.$cityForm.find('[data-js=firm-city-map]').attr('id'),
      'name': name,
      'address': [city, address].join(' '),
      'explanation': explanation,
      'info': phones,
      'addressInput': fields[1].input,
      'coordinatesInput': fields[3].input
    });
  }
};