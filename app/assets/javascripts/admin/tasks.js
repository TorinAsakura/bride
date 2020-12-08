$(function () {
  SendBox('.sv-task-categories-box');
  SendBox('.sv-tasks-box');

  $(document).on('click','[data-js=illustration-popup-close]', function(e) {
    e.preventDefault();
    $.fancybox.close();
  });

  $(document).on('change', '#task_type_task', function(e) {
    if ($(this).val() !== 'with_service') {
      $(".sv-task-with-service").css("display","none");
      $('.sv-admin-task__without-service').css('display','block');
    }
    else {
      $('.sv-admin-task__without-service').css('display','none');
      $(".sv-task-with-service").css("display","block");
    }
  });

});

function taskPosterView(){
  $('.sv-admin-task__upload-poster').click(function(e) {
    e.preventDefault();
    $("#task-upload-poster").trigger('click');
  });

  $("#task-upload-poster").change(function() {
    
    var reader;
    if (this.files && this.files[0]) {
      imgIllustr = $('#illustration-on-upload img');
      imgIllustr.removeAttr('style');
      reader = new FileReader();
      reader.onload = function(e) {
        var show_modal;
        show_modal = function() {
          $.fancybox.open($('#illustration-popup'), {
            fitToView: false,
            scrolling: 'no',
            closeBtn: false,
            afterShow: function() {
              var img, scale_width;
              update_jcrop();
              scale_width = imgIllustr.width();
              img = new Image();
              img.onload = function() {
                $("#illustration_scale").val(this.width / scale_width);
                $(img).css("max-width", "1000px");
                $(img).css("width", scale_width);
                $("#task-illustration img").replaceWith(img);
                $("#task-illustration img").click(function() {
                  show_modal();
                });
              };
              img.src = e.target.result;
            }
          });
        };
        imgIllustr.attr('src', e.target.result);
        imgIllustr.load(function() {
          show_modal();
        });
      };
      reader.readAsDataURL(this.files[0]);
    }
  });

  var boundx, boundy, saveCoords, updatePreview, update_jcrop;
  boundx = void 0;
  boundy = void 0;

  update_jcrop = function() {
    var imageHeight, imageWidth, leftTop, rightBottom, x, x2, y, y2;
    imgIllustr = $('#illustration-on-upload img');
    x = parseInt($("#illustration_x").val());
    y = parseInt($("#illustration_y").val());
    x2 = parseInt($("#illustration_x2").val());
    y2 = parseInt($("#illustration_y2").val());
    imageWidth = imgIllustr.width();
    imageHeight = imgIllustr.height();
    leftTop = {
      x: (imageWidth - x2 + x) / 2,
      y: (imageHeight - y2 + y) / 2
    };
    rightBottom = {
      x: leftTop.x + x2 - x,
      y: leftTop.y + y2 - y
    };
    var jcropAPI = imgIllustr.data('Jcrop');
    if (typeof jcropAPI !== "undefined" && jcropAPI !== null) {
        jcropAPI.destroy();
    }
    jcrop_obj = imgIllustr.Jcrop({
      onChange: updatePreview,
      onSelect: updatePreview,
      aspectRatio: (x2 - x) / (y2 - y),
      setSelect: [leftTop.x, leftTop.y, rightBottom.x, rightBottom.y]
    }, function() {
      var bounds;
      bounds = this.getBounds();
      boundx = bounds[0];
      boundy = bounds[1];
    });
  };

  updatePreview = function(coords) {
    var illustration, post_illustration_wrap, rx, ry;
    saveCoords(coords);
    post_illustration_wrap = $("#task-illustration");
    illustration = $("#task-illustration img");
    if (coords.w > 0 && coords.h > 0) {
      rx = post_illustration_wrap.width() / coords.w;
      ry = post_illustration_wrap.height() / coords.h;
      illustration.css({
        width: Math.round(rx * boundx) + "px",
        height: Math.round(ry * boundy) + "px",
        marginLeft: "-" + Math.round(rx * coords.x) + "px",
        marginTop: "-" + Math.round(ry * coords.y) + "px"
      });
    }
  };

  saveCoords = function(coords) {
    $("#illustration_x").val(coords.x);
    $("#illustration_y").val(coords.y);
    $("#illustration_x2").val(coords.x2);
    $("#illustration_y2").val(coords.y2);
  };
}

function editFirmCategories() {
  $(document).on('click', '.task-remove-file-link', function(e) {
    e.preventDefault();
    $(this).parent().remove();
  });

  $('.sv-admin__add-firm-category').on('click',function(e) {
    e.preventDefault();
    addCat = '<li class="sv-category">' + categoryFirmDiv + removeLink + '<ul></ul>' + addSubcategoryFirmLink + '</li>';
    $(this).parent().next().children('ul').append(addCat);
    $('select.sv-admin-category-select').select2();
  });

  $(document).off('click', '.sv-admin__add-firm-subcategory');
  $(document).on('click', '.sv-admin__add-firm-subcategory', function(e) {
    e.preventDefault();
    addSubcat = '<li><i class="login_arrow"></i>' + subcategoryFirmDiv + removeLink + '</li>';
    $(this).parent().children('ul').append(addSubcat);
    firmId = $(this).parent().find('select.sv-admin-category-select').val();
    replaceСontentsOfSelect($(this).parent().find('select.sv-admin-subcategory-select').last(), selectArrayFirm[firmId]);
  });

  $(document).off('change', '.sv-admin-category-select');
  $(document).on('change', '.sv-admin-category-select', function(e) {
    getFirmCatalogChildren($(this).val(), $(this));
  });

  $('#remove-task').on('click',function(e) {
    e.preventDefault();
    toggleConfirmIBox($(this));
  });
}


function editIdeaCategories() {
  $('.sv-admin__add-idea-category').on('click',function(e) {
    e.preventDefault();
    addCat = '<li class="sv-category">' + categoryIdeaDiv + removeLink + '<ul></ul>' + addSubcategoryIdeaLink + '</li>';
    $(this).parent().next().children('ul').append(addCat);
    $('select.sv-admin-category-idea-select').select2();
  });

  $(document).off('click', '.add-idea-subcategory');
  $(document).on('click', '.add-idea-subcategory', function(e) {
    e.preventDefault();
    addSubcat = '<li><i class="login_arrow"></i>' + subcategoryIdeaDiv + removeLink + '</li>';
    $(this).parent().children('ul').append(addSubcat);
    firmId = $(this).parent().find('select.sv-admin-category-idea-select').val();
    replaceСontentsOfSelect($(this).parent().find('select.sv-admin-subcategory-select').last(), selectArrayIdea[firmId]);
  });

  $(document).off('change', '.sv-admin-category-idea-select');
  $(document).on('change', '.sv-admin-category-idea-select', function(e) {
    getIdeaCategories($(this).val(), $(this));
  });

}

function replaceСontentsOfSelect(selectObj, currentArray) {
  if (typeof currentArray != 'undefined') {
    var option = '';
    for (i=0;i<currentArray.length;i++){
      option += '<option value="'+ currentArray[i].id + '">' + currentArray[i].name + '</option>';
    }
    selectObj.append(option);
  }
  selectObj.select2();
}

function loadFileForTask() {

  $('.sv-file-remove-ajax').click(function(e) {
    e.preventDefault();
    var this_href = this.href;
    $.ajax({
      url: this_href,
      type: 'DELETE'
    });
    this.parentNode.remove();
  });

  $("#task-files").fileupload({
    acceptFileTypes: /\.(jpeg|jpg|bmp|png|gif|JPEG|JPG|BMP|PNG|GIF|rar|doc|xsl|pdf|docx|RAR|DOC|XLS|PDF|DOCX)$/,
    sequentialUploads: true
  });

  $('[data-js=task-upload-file]').click(function(e) {
    e.preventDefault();
    $('#task-files-upload').trigger('click');
  });

  $('#task-files-upload').change(function() {
    if (this.files) {
      $.each(this.files, function(index, file) {
        var fileExt = file.name.split('.').pop();
        if (/docx|doc|pdf|xls|rar/.test(fileExt)){
          showLoadFile(file);
        }
        else if (/jpg|jpeg|gif|bmp|png/.test(fileExt)){
          showLoadImage(file);
        }
      });
    }
  });

  $('#task-send-form').click(function(e) {
    e.preventDefault();
    messageWait  = $('.sv-task-settings.wait');
    messageSaved = $('.sv-task-settings.saved');
    messageError = $('.sv-task-settings.error');

    messageWait.css('display', 'inline');

    function sendFiles(data) {
      taskFilesForm = $('#task-files');
      var url = taskFilesForm.attr('action').replace(/(tasks)\/([0-9]+)\//, '$1/' + data.id + '/');

      taskFilesForm.bind('fileuploadsubmit', function (e, data) {
        var inputs = data.context.find(':input');
        if (inputs.filter('[required][value=""]').first().focus().length) {
            return false;
        }
        data.formData = inputs.serializeArray();
      });

      taskFilesForm.fileupload({
        url: url
      }).bind('fileuploadstop', function(e) {
        if (data.status == 'success') {
          showTask(data.task_category_id, data.id);
        }
        messageWait.css('display', 'none')
        messageSaved.css('display', 'inline').fadeOut(2000);
      });

      if ($('td.start button').size() !== 0) {
        $('td.start button').trigger('click');
      } else {
        if (data.status == 'success') {
          showTask(data.task_category_id, data.id);
        }
        messageWait.css('display', 'none')
        messageSaved.css('display', 'inline').fadeOut(2000);
      }
    };

    function showErrorMessage() {
      messageWait.css('display', 'none')
      messageError.css('display', 'inline').fadeOut(4000);
    }

    $('#task-form').ajaxSubmit({
      success:  sendFiles,
      error:    showErrorMessage,
      dataType: 'json'
    });
  });
}

function toggleConfirmIBox(obj){
  var c_obj = $(obj).next();
  $obj = $(obj);
  $pop = $('div#sv-confirm-pop-ibox');
  if($pop.length==0){
    $('body').append('<div id="sv-confirm-pop-ibox"><i></i></div>');
    $pop = $('div#sv-confirm-pop-ibox');
    $ul = c_obj.find('ul');
    var offset = $obj.offset();
    $ul.clone().prependTo($pop);
    $pop.css({'top':offset.top-$pop.outerHeight(),'left':offset.left-$pop.outerWidth()/2+$obj.outerWidth()/2}).fadeIn();
  }else{
    $pop.remove();
  }
}

function getFirmCatalogChildren(firmId, firmObj) {
  $.ajax({
    url: '/admin/tasks/get_firm_catalog_children',
    type: 'GET',
    data: {'id': firmId},
    success: function(result) {
      selectArrayFirm[firmId] = result.tasks;
      if (typeof firmObj != 'undefined') {
        var subcategorySelects = firmObj.parent().find('select.sv-admin-subcategory-select');
        subcategorySelects.empty();
        replaceСontentsOfSelect(subcategorySelects, selectArrayFirm[firmId]);
      }
    }
  });
}

function getIdeaCategories(ideaId, ideaObj) {
  $.ajax({
    url: '/admin/idea/sections/' + ideaId +  '/get_categories',
    type: 'GET',
    success: function(result) {
      selectArrayIdea[ideaId] = result;
      if (typeof ideaObj != 'undefined') {
        var subcategorySelects = ideaObj.parent().find('select.sv-admin-subcategory-select');
        subcategorySelects.empty();
        replaceСontentsOfSelect(subcategorySelects, selectArrayIdea[ideaId]);
      }
    }
  });
}

function showTask(category_id, id) {
  $.ajax({
    url: '/admin/task_categories/' + category_id,
    type: 'GET',
    success: function(result) {
      $.ajax({
        url: '/admin/tasks/' + id + '/edit',
        type: 'GET'
      });
    }
  });
}

function showLoadFile(file) {
  var fileExt = file.name.split('.').pop();
  var btn, btnImg, div, extImg, desc, fileTitle, fileName;
  var fileTitleCont = $('#file_title').val();
  div = $('<div></div>');
  btnImg = new Image();
  btnImg.src = '/assets/sorted/sv-icon-small-close.png';
  btn = $('<div></div>').addClass('sv-file-remove').append(btnImg);
  extImg = new Image();
  extImg.src = '/assets/sorted/icon_ext/' + fileExt + '.png';
  ext = $('<div></div>').addClass('sv-file-extension').append(extImg);
  fileTitle = $('<p></p>').append(fileTitleCont);
  fileName = $('<p></p>').addClass('sv-task__load-file__size').append(file.name+' '+(file.size/1048576).toFixed(2)+' mb');
  desc = $('<div></div>').addClass('sv-file-name').append(fileTitle).append(fileName);
  $('<input>').attr({ type: 'hidden', id: '', name: 'file[title][]', value: fileTitleCont }).appendTo($('.file' + file.size));

  btn.click(function() {
    $('.file' + file.size).remove();
  });
  $('.file' + file.size + ' .cancel button').on('click', function() {
    $('.file' + file.size).remove();
  });
  div.addClass('sv-task__load-file').addClass('file' + file.size).
                                    append(ext).
                                    append(btn).
                                    append(desc).appendTo($('.sv-task__load-files'));
  $('#file_title').val('');
}

function showLoadImage(file) {
  var reader = new FileReader();
  reader.onload = function(e) {
  var btn, btnImg, div, img, desc, fileName;
  div = $('<div></div>');

  btnImg = new Image();
  btnImg.src = '/assets/sorted/sv-icon-small-close.png';

  btn = $('<div></div>').addClass('sv-file-remove').append(btnImg);
  img = new Image();
  img.src = e.target.result;

  ext = $('<div></div>').addClass('sv-admin-task__image-preview').append(img);
  fileName = $('<p></p>').append(file.name);
  desc = $('<div></div>').addClass('sv-admin-task__image-info').append(fileName);
  $('<input>').attr({ type: 'hidden', id: '', name: 'file[title][]' }).appendTo($('.file' + file.size));

  btn.click(function() {
    $('.file' + file.size).remove();
  });
  $('.file' + file.size + ' .cancel button').on('click', function() {
    $('.file' + file.size).remove();
  });

  div.addClass('sv-admin-task__image').addClass('file' + file.size).
                                     append(ext).
                                     append(btn).
                                     append(desc).appendTo($('.sv-admin-task__images'));
  };
  reader.readAsDataURL(file);
}

if (typeof RedactorPlugins === 'undefined') var RedactorPlugins = {};
RedactorPlugins.checkbox = {
    init: function()
    {
        this.buttonAdd('checkbox', 'Добавить CheckBox', this.insertCheckboxHtml);
    },
    insertCheckboxHtml: function()
    {
        randId = Math.floor(Math.random()*9999);
        this.insertHtml('<input type="checkbox" name="chechbox' + randId + '" value="' + randId + '" class="sv-event__input-checkbox">');
    }
}

