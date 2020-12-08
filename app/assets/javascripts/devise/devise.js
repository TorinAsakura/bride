$(document).ready(function() {
    $('.register-city-firm-link').click(function(){
        changeFirstCityBlock = $('#change-first-city');
        changeFirstCityBlock.data('modal', false);
        if ( $(this).parents('.fancybox-inner').length > 0 ) {
            changeFirstCityBlock.data('modal', true)
        }
    });
    $('.register-sphere-link').click(function(){
        changeFirstSphereBlock = $('#change-first-firm-catalog');
        changeFirstSphereBlock.data('modal', false);
        if ( $(this).parents('.fancybox-inner').length > 0 ) {
            changeFirstSphereBlock.data('modal', true)
        }
    });

  $('[data-js=link-modal-register]').click(function() {
    $('[data-js=link-tab-register]').tab('show');
  });

  $('[data-js=link-modal-login]').click(function() {
    $('[data-js=link-tab-login]').tab('show');
  });

  $('[data-js=link-tab-forgot-password]').click(function() {
    $('[data-js=link-tab-login]').parent('li').removeClass('active');
  });

  $('[data-js=login-email]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=login-password]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-email]').blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  }).focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  });

  $('[data-js=register-password]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-confirm-password]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-c-email]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-c-name]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-c-description]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-c-password]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=register-c-confirm-password]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $('[data-js=forgot-password-email]').focus(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').addClass('visible');
  }).blur(function(e) {
    $(e.currentTarget).parents('.field-block').children('.notification').removeClass('visible');
  });

  $(document).on('click', '.sv-login-role label', function(){
    $(this).closest('.sv-login-role').find('li').removeClass('active').find('label').removeClass('active');
    $(this).addClass('active');
    $(this).closest('.tab-content').find('.simple_form').resetClientSideValidations()
  });
});
