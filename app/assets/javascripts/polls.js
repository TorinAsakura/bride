function initPollUploader() {
  var handler;
  handler = !!$('.sv-polls-previews').data('remote_upload');

  var getFiles = function() {
    var result = [];
    $('.template-upload').each(function(i, template) {
      $.each($(template).data('data').files, function(j, file) {
        result.push(file);
      });
    });
    return result;
  }

  $('.sv-poll-submit').click(function(e) {
    if (!$('#poll_title').val()) {
      $('.sv-poll-error').show();
      $('#poll_title').focus();
      e.preventDefault();
    } else {
      if (!handler) {
        alert('Пожалуйста, выберите не менее двух изображений');
        e.preventDefault();
      }
    }
  });

  $('#poll_title').keydown(function() {
    $('.sv-poll-error').hide();
  });

  $('.sv-polls-upload-input').fileupload({
    'dataType': 'json',
    'autoUpload': false,
    'filesContainer': $('.sv-polls-previews'),
    'uploadTemplateId': 'polls-template-upload',
    'downloadTemplateId': null,
    'multipart': true,
    'previewMinWidth': 206,
    'previewMinHeight': 206,
    'previewMaxWidth': 206,
    'previewMaxHeight': 206
  }).bind('fileuploadadd', function() {
    if (!handler) {
      handler = true;
      $('.sv-poll-submit').click(function(event) {
        if ($('#poll_title').val()) {
          var filesToUpload = getFiles();
          if (filesToUpload.length < 2) {
            alert('Пожалуйста, выберите не менее двух изображений');
          } else {
            if (filesToUpload.length > 3) {
              alert('Пожалуйста, выберите не больше трех изображений');
            } else {
              $('html').css('cursor', 'wait');
              $('.sv-polls-upload-input').fileupload('send', { files: filesToUpload });
              $('.sv-poll-submit').unbind('click');
            }
          }
        }
        event.preventDefault();
      });
    }
  }).bind('fileuploadstop', function() {
    window.location.href = '/polls';
  });
}

//end fileupload section
function initAccordion() {
  var duration = 200,
      minOpacity = 0.0,
      maxOpacity = 0.5,
      heartOpacity = 0.6;
      shouldAnimate = $('.sv-poll-accordion-inner').attr('animate') === 'true';

  var getBackgroundWidth = function(div) {
    var img = new Image();
    img.src = $(div).css('background-image').match(/^url\("?(.+?)"?\)$/)[1];
    return img.width;
  };

  if (shouldAnimate) {
    // vote links
    $('.sv-poll-variant a').bind('mouseenter', function() {
      var $pollVariant = $(this).closest('.sv-poll-variant');
      $('.sv-poll-variant').each(function() {
        if (!$(this).is($pollVariant)) {
          $(this).find('.sv-poll-variant-fade').fadeTo(duration, maxOpacity);
        }
      });
    }).bind('mouseleave', function() {
      $('.sv-poll-variant').each(function() {
        $(this).find('.sv-poll-variant-fade').fadeTo(duration, minOpacity);
      })
    });

    // fade
    $('.sv-poll-variant').bind('mouseenter', function() {
      $(this).children('.sv-poll-vote').stop().fadeTo(duration, heartOpacity);
    }).bind('mouseleave', function() {
      $(this).children('.sv-poll-vote').stop().fadeOut(duration);
    });

    $('.sv-poll-vote').bind('mouseenter', function() {
      $(this).stop().fadeTo(duration, 1.0);
    }).bind('mouseleave', function() {
      $(this).stop().fadeTo(duration, heartOpacity);
    })
  }

  $('.sv-poll-variant').bind('mouseenter', function() {
    var $this,
        $that = $(this),
        $pollVariant = $(this),
        sumWidth = $('.sv-poll-accordion').width(),
        bgWidth = getBackgroundWidth(this),
        realWidth = $(this).width(),
        minWidth;
    minWidth = Math.floor((sumWidth - (realWidth < bgWidth ? bgWidth : realWidth)) / ($('.sv-poll-variant').length - 1));
    $('.sv-poll-variant').each(function() {
      $this = $(this);
      if (!$this.is($that)) {
        $this
          .stop()
          .animate({
            width: minWidth + 'px'
          }, {
            duration: duration,
            step: function() {
              $(this).css('overflow', 'visible');
            }
          });
      }
    });
    if ($pollVariant.width() < bgWidth) {
      $pollVariant
        .stop()
        .animate({
          width: bgWidth + 'px'
        }, {
          duration: duration,
          step: function() {
            $(this).css('overflow', 'visible');
          }
        });
    }
  }).bind('mouseleave', function() {
    var $this,
        sumWidth = $('.sv-poll-accordion').width(),
        realWidth;
    realWidth = Math.floor(sumWidth / $('.sv-poll-variant').length);
    $('.sv-poll-variant').each(function() {
      $this = $(this);

      $this.stop().animate({
        width: realWidth + 'px'
      }, {
        duration: duration,
        step: function() {
          $(this).css('overflow', 'visible');
        }
      });
    });
  });
}

$(document).ready(function() {
  $('.sv-polls-list').infinitescroll({
    navSelector: '.sv-polls-hidden-nav',
    nextSelector: '.sv-polls-hidden-nav link[rel=next]',
    itemSelector: '.sv-polls-list .sv-poll',
    msgText: 'Loading',
    appendCallback: false
  }, function (elements) {
    $.each(elements, function(index, element) {
      $('.sv-polls-list').append(element);
      if (index % 2 != 0) {
        $('.sv-polls-list').append('<div class="clear"></div>')
      }
    });
  });
});

