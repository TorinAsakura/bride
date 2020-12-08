$(function() {
  searchAdministrator();
  searchModerator();
  searchCity();

  $("#business a").click(function (e) {
    e.preventDefault();
    $(".tab-content input").attr('disabled','disabled');
    $(".tab-content div"+$(this).attr('href')+" input").removeAttr('disabled');
    $(this).tab('show');
  });
  $("#business a:first").click();
});

function makeArrayFromHash(map) {
  var a = [];
  for(var i in map) {
    if (map.hasOwnProperty(i)) {
      a.push(i);
    }
  }
  return a;
}

function searchModerator() {
  function format(data) {
    if (!data.id) return data.text; // optgroup
    return  data.text;
  }
  $("#firm_moderator_ids").select2({
    placeholder: "Выбрать модераторов",
    initSelection : function (element, callback) {
      var data = [];
      var elements_array = makeArrayFromHash(s2_moderators_map);
      $(element).val('');
      for (var i=0; i < elements_array.length; i++) {
        data.push({id: elements_array[i], text: s2_moderators_map[elements_array[i]]});
      }
      callback(data);
    },
    allowClear: true,
    minimumInputLength: 3,
    multiple: true,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "/search/",
      dataType: 'json',
      data: function (term, page) {
        return {
          q: term, // search term
          param: 'login'
        }
      },
      results: function (data, page) { // parse the results into the format expected by Select2.
        // since we are using custom formatting functions we do not need to alter remote JSON data
        return {results: data};
      }
    },
    formatResult:format,
    formatSelection:format

  });
}

function searchAdministrator() {
  function format(data) {
    if (!data.id) return data.text; // optgroup
    return  data.text;
  }
  $("#firm_user_id").select2({
    placeholder: "Выбрать администратора",
    initSelection : function (element, callback) {
      var data = [];
      var elements_array = makeArrayFromHash(s2_administrators_map);
      $(element).val('');
      for (var i=0; i < elements_array.length; i++) {
        data.push({id: elements_array[i], text: s2_administrators_map[elements_array[i]]});
      }
      //alert(data[0]['text']);
      callback(data);
    },
    allowClear: false,
    minimumInputLength: 3,
    multiple: true,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "/search/",
      dataType: 'json',
      data: function (term, page) {
        return {
          q: term, // search term
          param: 'login'
        }
      },
      results: function (data, page) { // parse the results into the format expected by Select2.
        // since we are using custom formatting functions we do not need to alter remote JSON data
        return {results: data};
      }
    },
    formatResult:format,
    formatSelection:format

  });
}
function searchCity() {
  function format(data) {
    if (!data.id) return data.text; // optgroup
    return  data.text;
  }
  $('#city_id').select2({
    placeholder: "Выбрать город",
    initSelection : function (element, callback) {
      var data = [];
      var elements_array = makeArrayFromHash(s2_cities_map);
      $(element).val('');
      for (var i=0; i < elements_array.length; i++) {
        data.push({id: elements_array[i], text: s2_cities_map[elements_array[i]]});
      }
      //alert(data[0]['text']);
      callback(data);
    },
    allowClear: false,
    minimumInputLength: 3,
    multiple: true,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "/city_search/",
      dataType: 'json',
      data: function (term, page) {
        return {
          q: term, // search term
          param: 'city'
        }
      },
      results: function (data, page) { // parse the results into the format expected by Select2.
        // since we are using custom formatting functions we do not need to alter remote JSON data
        return {results: data};
      }
    },
    formatResult:format,
    formatSelection:format
  });
}

$(document).ready(function() {
//  $(document).on('click', '.category-link', function(){
//    history.pushState({}, '', $(this).attr('href') );
//  })

//  // init city for links
//    $.each($('.category-link'), function(){
//      $(this).attr( 'href', $(this).attr('href')+'&city='+$('#city_filter').val());
//    });

  // firms#edit
  function initPartEditFormFirm () {
    hideAllPartEditFormFirm();
    removeClassActiveFromAllPartEditFormFirm();

    var anchor = document.URL.split('#')[1];
    if ( anchor == undefined || anchor == '' ) {
      showPartEditFormFirm($('#firm-control-panel-company-settings'));
      addClassActiveToPartEditFormFirm($('[data-part=firm-control-panel-company-settings]'));
    } else {
      showPartEditFormFirm( $('#' + $('.' + anchor).attr('data-part')) );
      addClassActiveToPartEditFormFirm($('.' + anchor));
    }
  }

  function hideAllPartEditFormFirm () {
    $('.firms-edit .firm-settings').hide();
  }

  function removeClassActiveFromAllPartEditFormFirm () {
    $('.firm-control-panel-link').parents('li').removeClass('active');
  }

  function showPartEditFormFirm (partID) {
    partID.show();
  }

  function addClassActiveToPartEditFormFirm (partID) {
    partID.parents('li').addClass('active');
  }

  // change slug
    function validateSlug(slug) {
      var re = /^[\w-_]+$/i;
      return re.test(slug);
    }

    function checkPresentOfSlug (slug) {
      $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/firms/check_slug_present',
        {
          firm_slug: slug
        },
        function(data, textStatus) {
          $('#firm-slug span').hide();
          if(data.result == true) {
            $('#firm-slug [type=submit]').hide();
            $('#firm-slug span.slug-dont-avaliable').show();
          } else {
            $('#firm-slug [type=submit]').show();
            $('#firm-slug span.slug-avaliable').show();
          }
        }
      );

      return false;
    }
    var firmSlug = $('#firm_slug').val();
    var canAjaxFlagSlug = true;

    $(document).on('mousedown, keyup', '#firm_slug', function(){
      if (canAjaxFlagSlug) {
        canAjaxFlagSlug = false;
        var slugInput = $(this);
        setTimeout(function(){
          canAjaxFlagSlug = true;
          var curentSlug = slugInput.val();

          if (firmSlug != curentSlug) {
            if (validateSlug(curentSlug)) {
              firmSlug = curentSlug;
              checkPresentOfSlug(curentSlug);
            } else {
              $('#firm-slug [type=submit]').hide();
              $('#firm-slug span.result').hide();
              $('#firm-slug span.not-valid').show();
            }
          }
        }, 1000);
      }
    });
  // end change slug

  // change email start
  var userEmail = $('#firm_user_attributes_email').val();
  var canAjaxFlagEmail = true;
  var wrapper = $('#firm-user-email');
  var emailChangedPopup = $('.sv-firm-email-changed-popup');
  var invalidEmailPopup = $('.sv-firm-email-invalid-popup');
  var emailAlreadyUsedPopup = $('.sv-firm-email-already-used-popup');

  function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  function checkPresentOfEmail (email) {
    $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/users/check_email_present', {
        user_email: email
      }, function(data, textStatus) {
        if(data.result) {
            emailAlreadyUsedPopup.show();
          wrapper.find('input[type=submit]').hide();
        } else {
          wrapper.find('input[type=submit]').show();
        }
      }
    );
    return false;
  }

  $(document).on('mousedown, keyup', '#firm_user_attributes_email', function(){
    emailChangedPopup.hide();
    invalidEmailPopup.hide();
    emailAlreadyUsedPopup.hide();
    if (canAjaxFlagEmail) {
      canAjaxFlagEmail = false;
      var emailInput = $(this);
      setTimeout(function(){
        canAjaxFlagEmail = true;
        var currentEmail = emailInput.val();

        if (userEmail != currentEmail) {
          if (validateEmail(currentEmail)) {
            userEmail = currentEmail;
            checkPresentOfEmail(currentEmail);
          } else {
            invalidEmailPopup.show();
            wrapper.find('input[type=submit]').hide();
          }
        }
      }, 1000);
    }
  });
  // change email end

  $(document).on('click', '.firm-control-panel-link', function() {
    hideAllPartEditFormFirm();
    removeClassActiveFromAllPartEditFormFirm();

    showPartEditFormFirm($( '#' + $(this).attr('data-part') ));
    addClassActiveToPartEditFormFirm($(this));
  })

  //init part of edit page
  initPartEditFormFirm();

  $('[data-js=firm-address-remove]').on('click', function(e) {
    e.preventDefault();

    $('[data-js=firm-address][data-id="' + $(this).data('id') + '"]').fadeOut();
    $('[data-js=firm-address-_destroy][data-id="' + $(this).data('id') + '"]').val('t');
  });

  $('[data-js=firm-base-address-address]').on('keypress', function() {
    $('[data-js=firm-base-address-coordinates]').val('f');
  });

  $('.sv-firm-albums__show-all').on('click', function(e) {
    e.preventDefault();

    $('.sv-firm-album').removeClass('sv-firm-album_hidden');
    $('.sv-firm-albums__show-all').addClass('sv-firm-albums__show-all_hidden');
  })
});

$(window).load(function() {
    $('[data-js=firm-base-address-time-start]').select2({ minimumResultsForSearch: -1 });
    $('[data-js=firm-base-address-time-end]').select2({ minimumResultsForSearch: -1 });

    initFirmsListIS('#sv-firms-list');
});

function initFirmsListIS (elem) {
    elem = $(elem).find('#sv-firm-search-result');
    if (elem.length > 0) {
        elem.infinitescroll('binding','unbind');
        elem.data('infinitescroll', null);
        $(window).unbind('.infscr');

        elem.infinitescroll({
            navSelector: '#sv-firms-paginate',
            nextSelector: '#sv-firms-paginate a.next',
            itemSelector: '.sv-item-firm',
            maxPage: elem.data('maxPage')
        });
    }
}

function initCarousel() {
  var carousel = $('.sv-firm-carousel');
  if (carousel.length > 0) {
    carousel.carouFredSel({
      width: 650,
      height: 200,
      pagination: '.sv-firm-carousel-control',
      items: {
        visible: 1
      },
      auto: {
        duration: 700
      },
      scroll: {
          pauseOnHover    : true,
        onBefore: function(data) {
          data.items.visible.each(function() {
            var $this = $(this),
                title = $this.data('title'),
                description =  $this.data('description'),
                link = $this.data('link'),
                destroyLink = $this.data('destroy-link'),
                imageLink = $this.data('image-link');
            $('[data-js=firm-banner-remove-link]').attr('href', destroyLink);
            $('[data-js=firm-banner-edit-link]').data('image-link', imageLink);
            if (title || description) {
              $('.sv-firm-banner-panel').show();
              $('.sv-firm-banner-link').attr('href', link);
              $('.sv-firm-banner-title').html(title);
              $('.sv-firm-banner-description').html(description);
            } else {
              $('.sv-firm-banner-panel').hide();
            }
          });
        }
      }
    });
  }
}

function initAddFieldsLink() {
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
    $('select').select2();
  });
}

$(document).ready(function() {
  initAddFieldsLink();
  initCarousel();

  new FirmCatalogSelector({
    sphere: '.fields_for_firm #firm_base_sphere_id',
    catalog: '.fields_for_firm #firm_catalog_id',
    catalogList: '.fields_for_firm select.firm_catalog_ids',
    hiddenElement: '.fields_for_firm .login_arrow, .fields_for_firm .login_registration_select_down',
    hiddenClass: 'sv-firm-registration-hidden'
  });

  new FirmBannerEditor();

  new FirmLogoEditor();

  $('[data-js=firm-logo-destroy]').on('click', function(e) {
    e.preventDefault();

    $.fancybox.open('#sv-remove-firm-logo', {
      'fitToView': false,
      'scrolling': 'no',
      'helpers' : {
        'overlay' : {
          'closeClick': false
        }
      }
    })
  });

  new FirmCitySelector();

  $('[data-js=firm-show-phone-link]').on('click', function(e) {
    e.preventDefault();
    $.getScript($(this).data('url'));
  });

  $(document).on('click', '[data-js=firms-search-link]', function(e) {
    e.preventDefault();

    $('[data-js=firms-search-form]').slideToggle();
  });

  $('div.sv-i-phone').click( function (e) {
    $('div.sv-i-phone.active').not(this).removeClass('active');
    $(this).toggleClass('active');
  });
});
