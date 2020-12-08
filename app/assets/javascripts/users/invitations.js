function search_couple(){
  function format(data) {
    if (!data.id) return data.text; // optgroup
    return  data.text;
  }

  $("#couple_id").select2({
    maximumSelectionSize:2,
    minimumInputLength:3,
    formatInputTooShort:function (input, min) {
      return "Введите больше " + (min - input.length) + " символов";
    },
    formatNoMatches:function () {
      return "Ничего не найдено";
    },
    formatSearching:function () {
      return "Ищем...";
    },
    placeholder:"Найди свою половинку",
    ajax:{ // instead of writing the function to execute the request we use Select2's convenient helper
      url:"/couple_search.json",
      dataType:'json',
      data:function (term, page) {
        return {
          q:term, // search term
          page_limit:10 // currentlu unused
        };
      },
      results:function (data, page) { // parse the results into the format expected by Select2.
        // since we are using custom formatting functions we do not need to alter remote JSON data
        return {results:data};
      },

      formatResult:format,
      formatSelection:format
    },
  });

}

$(function () {

  //$("#new_user").live('submit', function(){
  $("document").on('submit', "#new_user", function(){
  	var val = $('.existed_user:checked').val(),
  		email = $("#user_email").val(),
  		couple = $("#couple_id").val();
  	
  	if(val == '0' && email == '')
	  	if(!confirm('Вы не указали email вашей пары, в этом случае вы будите без пары'))
	  		return false;
	  		
	if(val == '1' && couple == '')
		return false;
  });

  //$('.existed_user').live('click', function () {
  $("document").on('click', '.existed_user', function () {
    var val = $(this).val();
    if (val == '1') {
      $('.required').attr('disabled', 'dosabled');
    } else {
      $('.required').removeAttr('disabled');
    }
  });

});
