function align_center(){
	$("#next img").load(function(){
		var height = $(this).height();
		if (height < 500)
			$(this).css("padding-top", ((500 - height) / 2) + "px");
	});
}



$(function () {
	//$("#next").live("click", function(){
	$(document).on("click", "#next", function(){
		if(!this.href){
			$('#edit .modal').modal('hide');
		}
	});
	
	//$("#delete_photo").live("click", function(){
	$(document).on("click", "#delete_photo", function(){
		$("#next").click();
	});
	
	//$("#make_cover").live("click", function(){
	$(document).on("click", "#make_cover", function(){
		var self = this;
		$.get(this.href, function(data, e){
			var html = $(self).html(),
				parent = $(self).parent();
			$(self).remove();
			$(parent).html(html);
		},
		'JSON');
		return false;
	});
	
	//$("#make_avatar").live("click", function(){
	$(document).on("click", "#make_avatar", function(){
		var self = this;
		$.get(this.href, function(data, e){
			var html = $(self).html(),
				parent = $(self).parent();
			$(self).remove();
			$(parent).html(html);
		},
		'JSON');
		return false;
	});
	
});
