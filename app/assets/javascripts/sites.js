// sites#edit
$(document).ready(function() {
  // change address
  if ($('[data-part=site-address]').length != 0) {
    function validateAddress(address) {
      var re = /^[\w-_]+$/i;
      return re.test(address);
    }

    function checkPresentOfAddress (address) {
      $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/sites/check_name_present',
        {
          site_name: address
        },
        function(data, textStatus) {
          $('[data-part=site-address] span').hide();
          if(data.result == true) {
            $('[data-part=site-address] [type=submit]').hide();
            $('[data-part=site-address] span.address-dont-avaliable').show();
            $('[data-part=site-address] span.address-avaliable').hide();
          } else {
            $('[data-part=site-address] [type=submit]').show();
            $('[data-part=site-address] span.address-dont-avaliable').hide();
            $('[data-part=site-address] span.address-avaliable').show();
          }
        }
      );

      return false;
    }
    var siteAddress = $('[data-part=site-address]').val();
    var canAjaxFlagAddress = true;

    $(document).on('keyup', '#site_name', function(){
      if (canAjaxFlagAddress) {
        canAjaxFlagAddress = false;
        var addressInput = $(this);
        setTimeout(function(){
          canAjaxFlagAddress = true;
          var curentAddress = addressInput.val();

          if (siteAddress != curentAddress) {
            if (validateAddress(curentAddress)) {
              siteAddress = curentAddress;
              checkPresentOfAddress(curentAddress);
            } else {
              $('[data-part=site-address] [type=submit]').hide();
              $('[data-part=site-address] span.updated').hide();
              $('[data-part=site-address] span.not-valid').show();
              $('[data-part=site-address] span.address-avaliable').hide();
            }
          }
        }, 1000);
      }
    });
  }
  // end change address

  // change base settings
  if ($('[data-part=base-settings]').length != 0) {
    $(document).on('keyup', '[data-part=base-settings] input', function(){
      $('[data-part=base-settings] [type=submit]').show();
      $('[data-part=base-settings] span.updated').hide();
    });

    $(document).on('change', '[data-part=base-settings] select', function(){
      $('[data-part=base-settings] [type=submit]').show();
      $('[data-part=base-settings] span.updated').hide();
    });
  }
  // end change base settings

  // poster-preview
  function miniSitePreviewImg(input, previewTarget) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      window.miniSitePosterPreview = previewTarget;
      reader.onload = function (e, preview) {
        $(window.miniSitePosterPreview).attr('src', e.target.result);
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  $('[data-js=poster-img-input]').change(function() {
    previewTarget = $(this).parents('.firm-banner').find('.firm-banner-img');
    miniSitePreviewImg(this, previewTarget);
  });
  // end poster-preview

  // set active element of aside menu on minisite show action
  if ( $('.mini-site').size() >= 1 ) {
    $('[data-js=' + $('.sv-article').data('js') + ']').parents('li').addClass('active');
  }
  // set active element of aside menu on minisite show action
  if ( $('.mini-site-edit').size() >= 1 ) {
    $('[data-js=' + $('.sv-wraper').data('js') + ']').parents('li').addClass('active');
  }

  // show/hide site code field
  $(document).on('change', '#site_privacy', function (e) {
    if (1 == $(this).val())
      $('#site_code').show();
    else
      $('#site_code').hide();
  }).change();

  // password field notification
  $('#site_code').focus(function(e) {
      $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
      $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });
});
