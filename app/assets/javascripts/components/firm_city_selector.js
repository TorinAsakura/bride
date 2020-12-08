function FirmCitySelector() {
  $('.sv-firm-city-location').removeClass('sv-firm-city-location_loading');
  $('.sv-firm-city-select').chosen();

  this.initSelect();
  this.initCatalog();

  $('.sv-firm-side-city-contacts').first().removeClass('sv-firm-side-city-contacts_hidden');
  $('.sv-firm-side-city-map').first().removeClass('sv-firm-side-city-map_hidden');

  $('[data-js=side-city-select]').on('click', function() {

  });
}

FirmCitySelector.prototype.initSelect = function() {
  var city, $this;

  $('.sv-firm-city-select').on('change', function() {
    $this = $(this);

    $('.sv-firm-side-city-contacts').addClass('sv-firm-side-city-contacts_hidden');
    $('#firm-city-contacts-' + $this.val()).removeClass('sv-firm-side-city-contacts_hidden');

    $('.sv-firm-side-city-map').addClass('sv-firm-side-city-map_hidden');
    $('#firm-side-city-map-' + $this.val()).removeClass('sv-firm-side-city-map_hidden');
  });
};

FirmCitySelector.prototype.initCatalog = function () {
  var resetActive;

  resetActive = function () {
    $('ul.sv-categories a.active, ul.sv-categories li.active').removeClass('active');
  };

  $('ul.sv-categories > li > span').on('click', 'a', function (e) {
    e.preventDefault();

    resetActive();
  });

  $('ul.sv-categories > li > ul > li').on('click', 'a', function (){
    $('#sv-firms-list-title').find('[data-js=catalog-title]').html($(this).data('title'));
    $('ul.sv-categories > li > ul > li.active').removeClass('active');
    $(this).parent().addClass('active');
  });

  $('ul.sv-categories > li > a').on('click', function (e) {
    e.preventDefault();

    resetActive();
  });
};
