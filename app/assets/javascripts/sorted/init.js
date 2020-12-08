$(function(){
	$('select').filter(function(item) { return !$(this).data('select2-disabled') }).each(function(){
        var options = {};
        $.extend(options, $(this).data('select2-options'));
        $(this).select2(options);
    });
	$('input.datepicker').datepicker({
      changeMonth: true,
      changeYear: true
    });
});