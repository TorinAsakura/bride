$(function(){

  $('.fancybox').fancybox({
    'padding':0,
    'fitToView':false,
    'maxWidth':800,
    'afterShow':function(){
      $('div.fancybox-inner #sv-article-detail div.sv-article-scrolls ul.sv-article-list-wrap').mCustomScrollbar('destroy');
      $('div.fancybox-inner #sv-article-detail div.sv-article-scrolls ul.sv-article-list-wrap').mCustomScrollbar({
        horizontalScroll:true,
        theme:'svadba',
        mouseWheelPixels:$('div.fancybox-inner #sv-article-detail div.sv-article-scrolls li.sv-article-list-block').outerWidth(true)
      });
      
      $('div.fancybox-inner #sv-video-detail div.sv-video-scrolls ul.sv-video-list-wrap').mCustomScrollbar('destroy');
      $('div.fancybox-inner #sv-video-detail div.sv-video-scrolls ul.sv-video-list-wrap').mCustomScrollbar({
        horizontalScroll:true,
        theme:'svadba',
        mouseWheelPixels:$('div.fancybox-inner #sv-video-detail div.sv-video-scrolls li.sv-video-list-block').outerWidth(true)
      });
    }
  });

  $("[rel=tooltip]").tooltip({
    'animation':false,
    'placement':'bottom',
    'container':'body'
  });
  
  $('ul.sv-login-role input').change(function(){
    if($(this).is(':checked')){
      $('div.sv-login-opacity div.sv-bg-trans-white').hide();
      $(this).parents('ul.sv-login-role').find('label.active').removeClass('active');
      $(this).parent().addClass('active');
      
      if($(this).val() == '1'){
        $(this).parents('form').find('input.sv-name').attr({'placeholder':'Ф.И.О.','title':'Ф.И.О.'});
      }else{
        $(this).parents('form').find('input.sv-name').attr({'placeholder':'Наименование компании','title':'Наименование компании'});
      }
    }
  });
  $('ul.sv-login-role input').change();
  
  $('input.register_pass_1, input.register_pass_2').change(function(){
    var f = $(this).parents('form');
    var p1 = $(f).find('input.register_pass_1').val();
    var p2 = $(f).find('input.register_pass_2').val();
    var r = $(f).find('div.register_pass_result');
    if(p1 && p2 && p1.length > 0 && p2.length > 0){
      if(p2 == p1){
        $(r).addClass('ok').removeClass('err').text('Пароли совпадают!');
      }else{
        $(r).addClass('err').removeClass('ok').text('Пароли не совпадают!');
      }
      $(r).show();
    }else{
      $(r).hide();
    }
  });

  $('div.sv-plan-dates').mCustomScrollbar({
    horizontalScroll:true,
    theme:'svadba'
  });
  $('div.sv-scroll').mCustomScrollbar({
    horizontalScroll:true,
    theme:'svadba'
  });

  var svWhere = $('#sv-search-box').find('ul.sv-where');
  svWhere.find('li input').change(function() {
    var colors = $(this).parents('form').find('ul.sv-color');
    svWhere.find('li.active').removeClass('active');
    $(this).parent().addClass('active');
    if ('idea' === $(this).val()) {
      colors.removeClass('hidden');
    } else {
      colors.addClass('hidden');
    }

  });

  $('div.sv-i-user').click(function(){
    $('div.sv-i-user.active').not(this).removeClass('active');
    $(this).toggleClass('active');
    toggleIBox(this);
  });

  $('#sv-company-side-categories div.location span').click(function(){
    var $form = $(this).next('form');
    $form.fadeIn();
    var $input = $form.children('input');
    lastLocationVal = $input.val();
    $input.val('').focus();
  });

  initJournalTabsSwitch();
});
var p_obj = false;
function toggleIBox(obj){
  var c_obj = $.data(obj);
  $obj = $(obj);
  $pop = $('div#sv-pop-ibox');
  if(c_obj == p_obj){
    $pop.fadeOut();
    p_obj = false;
    return p_obj;
  }else{
    p_obj = c_obj;
  }
  if($pop.length==0){
    $('body').append('<div id="sv-pop-ibox"><i></i></div>');
    $pop = $('div#sv-pop-ibox');
  }else{
    $pop.hide().html('<i>');
  }
  $ul = $obj.find('ul');
  var offset = $obj.offset();
  $ul.clone().prependTo($pop);
  $pop.css({'top':offset.top-$pop.outerHeight(),'left':offset.left-$pop.outerWidth()/2+$obj.outerWidth()/2}).fadeIn();
}

function initJournalTabsSwitch() {
  var journal = $('#sv-read-it');

  journal.find('.sv-view-tab').on('click', function (e) {
    e.preventDefault();

    if ($(this).not('.active')) {
      var $tab = journal.find('.sv-view-tab.active').removeClass('active');
      $(this).addClass('active');
      journal.find('.sv-article-list-wrap').removeClass($tab.attr('rel')).addClass($(this).attr('rel'));
    }
  });
}
