$(function () {
	//$("#country_id").live('change', function(){
	$(document).on('change', "#country_id", function(){
		if(this.value == "") {
			$("#region_id").html("");
			$("#region_id").attr("disabled", true);
			$("#region_id").change();
		}
		else {
			$("#user_city").html("");
			$.get("/regions/" + this.value);
		}
	}).change();

	//$("#region_id").live('change',function(){
	$(document).on('change', "#region_id", function(){
		if(this.value == "") {
			$("#user_city").html("");
			$("#user_city").attr("disabled", true);
		}
		else {
			$.get("/cities/" + this.value);
		}
	}).change();
});
