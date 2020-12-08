function serilizeIds(list) {
  ids = $.makeArray(list.find('li').map(function(){return $(this).data('id')}));
  return { ids: ids };
};
