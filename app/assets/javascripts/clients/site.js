//= require jquery
//= require jquery_ujs

//= require bootstrap

//= require clients/jquery.vegas
//= require autoresize.jquery.js
//= require jquery.iframe-transport.js
//= require jquery-fileupload
//= require jquery.infinitescroll
//= require jQuery.tubeplayer.min
//= require clients/bootstrap.select

//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive

//= require clients/datatables.js

//= require best_in_place
//= require best_in_place.purr

//= require masonry.min
//= require multipleFilterMasonry

//= require main/fancybox/jquery.fancybox.pack
//= require main/fancybox/helpers/jquery.fancybox-buttons
//= require main/fancybox/helpers/jquery.fancybox-thumbs
//= require main/fancybox/helpers/jquery.fancybox-media

//= require components/auxiliary_viewer
//= require components/modal_viewer
//= require components/comment_form
//= require components/comment
//= require components/attachment_photo_uploader
//= require components/attachment_video_uploader
//= require components/video_search_form
//= require components/album_viewer
//= require components/album_form
//= require components/photo_edit_form
//= require components/photo_uploader
//= require components/photo_viewer
//= require components/social_auth

//= require albums/slider
//= require videos

//= require components/color_search_form
//= require components/idea_category_selector
//= require components/idea_viewer
//= require idea/hover_background
//= require idea/filtered_categories
//= require ideas

//= require clients/site/all

$(function(){

    $('.datatables').dataTable({"sPaginationType": "bs_full"});
    /** не забыть
     $('.datatables').dataTable({"sPaginationType": "bs_normal"});
     $('.datatables').dataTable({"sPaginationType": "bs_two_button"});
     $('.datatables').dataTable({"sPaginationType": "bs_four_button"});
     $('.datatables').dataTable({"sPaginationType": "bs_full"});
     */
})