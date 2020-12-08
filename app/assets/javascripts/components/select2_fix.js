$(document).on('select2-open', 'select', function() {
    var that = this;

    $('select').each(function() {
        if (that != this) {
            $(this).select2('close');
        }
    });
});

$(document).on("click", function(){
    $.each($(".select2-container-active"), function(index, elem){
        $(elem).select2("close");
    });
});

$(document).ready(function(){
    $(".select2-container").on("click", function(){
        var select2InstancesForClose = $(".select2-container-active").slice(0, -1);
        select2InstancesForClose.select2("close");
    })
});

$.extend($.fancybox.defaults, {
    beforeClose: function(){
        $('.fancybox-wrap').find('.simple_form').find('select, input').each(function(){
            $(this).select2("close");
        })
    }
});