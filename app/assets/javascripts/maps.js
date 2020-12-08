window.maps = {};

ymaps.ready(function() {
  window.iconLayout = ymaps.templateLayoutFactory.createClass(
    '<div id="layout-element" class="sv-firm-placemark" style="background: $[properties.iconColor]">$[properties.iconContent]</div>' +
      '<div class="sv-firm-placemark-triangle" style="border-top: 10px solid $[properties.iconColor]"></div>', {
      'build': function () {
        this.constructor.superclass.build.call(this);
      }
    }
  );
});

function initMap(options) {
  var id,
      addresses,
      city,
      data,
      map,
      geocoder,
      zoom,
      zoomControl,
      button,
      draggable,
      defaults,
      showMarker;

  defaults = {
    'addresses': '[]',
    'city': false,
    'zoom': 12,
    'zoomControl': false,
    'draggable': false
  };

  options = $.extend({}, defaults, options);

  id = options.id;
  addresses = options.addresses;
  city = options.city;
  zoom = options.zoom;
  zoomControl = options.zoomControl;
  draggable = options.draggable;

  data = JSON.parse(addresses);
  map = new ymaps.Map(id, { center: [55.75, 37.50], controls: ['fullscreenControl'] });
  window.maps[id] = map;
//  button = new ymaps.control.Button({
//      data: {
//        image: '/assets/sorted/sv-icon-map-fullscreen.png',
//        title: 'Переключить в полноэкранный режим'
//      }
//    }, {
//      selectOnClick: true
//    }
//  );
//  button.events.add('click', function() {
//    $('#' + id).toggleClass('sv-map-fullscreen');
//    map.container.fitToViewport();
//  });
//  map.controls.add(button, { top: 5, right: 5 });
  if (zoomControl) {
    map.controls.add('zoomControl', { top: 5, left: 5 });
  }

  showMarker = function(map, geocoder, iter, item) {
    geocoder.then(function (res) {
      if (res) {
        var point = res.geoObjects.get(0);
        point.properties.set('iconContent', (iter + 1).toString());
        point.properties.set(
          'balloonContentBody', [
            '<p><b>' + item.name + '</b></p>',
            '<p>Адрес: ' + item.explanation + '</p>',
            '<p>' + (item.workingTime || '') + (item.phone  || '') + '</p>'
          ].join('')
        );
        point.properties.set('iconColor', item.color);
        point.options.set('iconShadow', false);
        point.options.set('iconContentLayout', window.iconLayout);
        if (draggable) {
          point.options.set('draggable', true);
          (function(_item, _point) {
            var $addressField, $booleanField;

            $addressField = $('[data-js=firm-address-address][data-id="' + _item.id + '"]');
            $booleanField = $('[data-js=firm-address-coordinates][data-id="' + _item.id + '"]');

            if ($addressField.length < 1) {
              $addressField = $('[data-js=firm-base-address-address]');
              $booleanField = $('[data-js=firm-base-address-coordinates]');
            }

            _point.events.add('drag', function() {
              $addressField.val(_point.geometry.getCoordinates());
              $booleanField.val('t');
            });
          })(item, point);
        }
        map.geoObjects.add(point);
        if (iter == 0) {
          map.setCenter(point.geometry.getCoordinates(), zoom);
        }
        var marker = $('[data-js=firm-address][data-id=' + item.id + '] .sv-firm-address-marker');
        marker.css('background-color', item.color);
        marker.find('.sv-firm-address-marker-number').html(iter + 1);
        marker.find('.sv-firm-address-marker-triangle').css('border-top-color', item.color);
      }
    });
  };

  if (city) {
    geocoder = ymaps.geocode(city);
    geocoder.then(function(res) {
      if (res) {
        var point = res.geoObjects.get(0);
        map.setCenter(point.geometry.getCoordinates(), zoom);
      }
    });
  }

  $.each(data, function(index, item) {
    geocoder = ymaps.geocode(item.address);
    showMarker(map, geocoder, index, item);
  });
}

function addMarkerToMap(options) {
  var map,
      geocoder,
      id = options.id,
      name = options.name,
      address = options.address,
      explanation = options.explanation,
      $address = options.addressInput,
      $coordinates = options.coordinatesInput;

  map = window.maps[id];
  geocoder = ymaps.geocode(address);
  geocoder.then(function(res) {
    if (res) {
      var point = res.geoObjects.get(0);
      point.properties.set('iconContent');
      point.properties.set(
        'balloonContentBody', [
          '<p><b>' + name + '</b></p>',
          '<p>Адрес: ' + explanation + '</p>'
        ].join('')
      );
      point.properties.set('iconColor', 'blue');
      point.options.set('iconShadow', false);
      point.options.set('iconContentLayout', window.iconLayout);
      point.options.set('draggable', true);
      point.events.add('drag', function() {
        $address.val(point.geometry.getCoordinates());
        $coordinates.val('t');
      });
      map.geoObjects.add(point);
    }
  });
}
