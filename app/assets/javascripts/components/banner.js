function Banner() {
  this.$ad = $('[data-js=banner-ad]');
  this.$form = $('[data-js=banner-form]');

  this.initCarousel();
  this.update($('.sv-banner__image').first());
}

Banner.prototype.initCarousel = function() {
  var carousel,
      that = this;

  carousel = $('[data-js=banner-carousel]');
  if (carousel.length) {
    carousel.carouFredSel({
      width: 960,
      height: 360,

      items: {
        visible: 1
      },

      auto: {
        duration: 700
      },

      scroll: {
        onBefore: function(data) {
          data.items.visible.each(function () {
            that.update(this);
          });
        }
      }
    });
  }
};

Banner.prototype.update = function(item) {
  var $item = $(item),
      type = $item.data('banner-type');

  if (type === 'system') {
    this.$form.show();
    this.$ad.hide();
  } else if (type === 'ad') {
    this.$form.hide();
    this.$ad.show();
    this.updateAd($item.data('title'), $item.data('description'), $item.data('link'));
  }
};

Banner.prototype.updateAd = function(title, description, link) {
  $('[data-js=banner-ad-description]').html(description);
  $('[data-js=banner-ad-title]').html(title);
  $('[data-js=banner-ad-link]').attr('href', link);
};
