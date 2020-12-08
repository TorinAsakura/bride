function FirstVisitPopup(html) {
  this.html = html;
  this.$wrapper = $('#edit');

  this.fancyboxOptions = {
    'fitToView': false,
    'scrolling': 'no',
    'closeBtn': false,
    'padding': 0,
    'afterClose': function () {
      window.auxiliaryViewer = new AuxiliaryViewer($('[data-js=post-form-warning]').html());
      window.auxiliaryViewer.show();
    }
  };

  $(document).on('click', '[data-js=post-form-warning-ok]', function (e) {
    e.preventDefault();
    window.auxiliaryViewer.allowClose = true;
    $.fancybox.close();
  });

  $(document).on('click', '[data-js=post-form-warning-cancel]', function (e) {
    e.preventDefault();
    $.fancybox.close();
  });

  $(document).on('click', '[data-js=first-visit__skip-step]', function(e){
    e.preventDefault();
    thisStep = $(this).parents('.step');
    if (thisStep.next('.step').length) {
      thisStep.hide();
      thisStep.next('.step').show();
    }
  });

  $(document).on("ajax:success", '#sv-first-visit__form-step1, #sv-first-visit__form-step2, #sv-first-visit__form-step3',
    function(evt, data, status, xhr){
      $(this).find('a[data-js=first-visit__skip-step]').click()
  });
}

FirstVisitPopup.prototype.show = function () {
  var that = this;
  this.$step = this.$step || 1;
  this.$wrapper.html(this.html);
  this.$weddingDateInput = $('#wedding_date');

  $.fancybox.open(this.$wrapper, $.extend({}, this.fancyboxOptions, { 
    'beforeShow': function () {
      new CitySelector();
      $('.sv-first-visit select').select2();
      that.showStep();
      that.initBeatPicker();
    } 
  }));
};

FirstVisitPopup.prototype.resume = function () {
  $.fancybox.open(this.$wrapper, this.fancyboxOptions);
};

FirstVisitPopup.prototype.initBeatPicker = function () {
  var that = this;
  var now = new Date();
  var curDate = now.getFullYear()+','+(now.getMonth()+1)+','+now.getDate(); 

  options = $.extend({
    'dateInputNode': that.$weddingDateInput,
    'startDate': curDate,
    'disablingRules': [{from:curDate,to:'<'}]
  },customBeatpickerOptions)

  instance = new BeatPicker(options);
};

FirstVisitPopup.prototype.showStep = function () {
  var that = this;
  $('.sv-first-visit .step').hide();
  $('.sv-first-visit #step' + that.$step).show();
};
