function FirmSettingsCitySelector(id, name) {
  this.id = id;
  this.name = name;

  this.initButtons();
  this.initMap();
}

FirmSettingsCitySelector.prototype.initButtons = function () {
  var that = this;

  $('[data-js=new-address-link]').on('click', function() {
    window.cityFirmForm = $(this).closest('form')
  });

  $('[data-js=city-firm-remove-btn][data-id=' + this.id + ']').on('click', function(e) {
    e.preventDefault();
    $('[data-js=city-firm-select-wrapper][data-id=' + that.id + ']').remove();
    $('[data-js=city-firm-fields][data-id=' + that.id + ']').remove();
  });
};

FirmSettingsCitySelector.prototype.initMap = function () {
  var $wrapper = $('[data-js=city-firm-fields][data-id=' + this.id + ']')
      mapId = $wrapper.find('[data-js=firm-city-map]').attr('id');
  if ( !!mapId ) {
      if (window.maps[mapId]) {
          window.maps[mapId].destroy();
      }

      initMap({
          'id': mapId,
          'city': this.name,
          'zoomControl': true
      });
  }
};