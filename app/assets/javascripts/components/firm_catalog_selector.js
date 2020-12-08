function FirmCatalogSelector(options) {
  this.$sphere = $(options.sphere);
  this.$sphereList = $(options.catalogList).last();
  this.$catalog = $(options.catalog);
  this.$catalogParams = options.catalogParams;
  this.$hiddenElement = $(options.hiddenElement);
  this.hiddenClass = options.hiddenClass;

  this.initSelect();
}

FirmCatalogSelector.prototype.initSelect = function() {
  var that = this;

  $.each([this.$sphere, this.$catalog], function(index, $selector) {
    $selector.on('change', function(e) {
      var $this, params;

      $this = $(this);

      if ($this.is(that.$catalog)) {
        params = $.extend(that.$catalogParams, {
            parent_id: $this.val()
        });
      } else {
        params = { id: $this.val() }
      }
        that.$sphereList.select2("val", "");

      $.ajax({
        url: '/firms/get_firm_catalog_children',
        data: params,
        dataType: 'json',
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function(data) {
          that.populateSelect(data);
        }
      });
    });
  });
};

FirmCatalogSelector.prototype.populateSelect = function(data) {
    var key, i;
    $this = this;
    $this.$sphereList.empty();
    if (this.$hiddenElement.length > 0) {
        this.$hiddenElement.removeClass(this.hiddenClass);
    }
    if (data.firms.length > 0) {
        $.each(data.firms, function(i, firm){
            $this.$sphereList.append(new Option(firm.name, firm.id));
        });
        this.$sphereList.select2('enable');
    } else {
        this.$sphereList.select2('disable');
    }
};