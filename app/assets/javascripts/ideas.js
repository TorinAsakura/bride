$(document).ready(function() {
  new IdeaCategorySelector();
});

$(window).load(function() {
    $('.sv-idea_hidden').removeClass('sv-idea_hidden');
    var searchSectionSelect =  $('select.sv-ideas__search-section-select');
    if (searchSectionSelect.length > 0) {
        searchSectionSelect.select2({'minimumResultsForSearch': -1});
    }

    var searchCategorySelect = $('select.sv-ideas__search-category-select');
    if (searchCategorySelect.length > 0) {
        searchCategorySelect.select2({'minimumResultsForSearch': -1});
    }

  var msnry,
      ideas = $('.sv-ideas'),
      homeIdeas  = $('.sv-home__ideas'),
      minisiteIdeas = $('.sv-minisite-ideas__grid');

  if (ideas.length && !homeIdeas.length) {
    msnry = new Masonry(ideas.get(0), {
      'itemSelector': '.sv-idea',
      'columnWidth': 205,
      'gutter': 10,
      'isFitWidth': true
    });

    ideas.infinitescroll({
      navSelector: '.sv-ideas__nav',
      nextSelector: '.sv-ideas__nav a.next',
      itemSelector: '.sv-idea',
      appendCallback: false,
        maxPage: ideas.data('maxPage')
    }, function (elems) {
      $.each(elems, function(index, elem) {
        ideas.append(elem);
        $(elem).find('img').on('load', function() {
          $(elem).removeClass('sv-idea_hidden');
          msnry.appended(elem);
        })
      });
    });
  }


    if (minisiteIdeas.length > 0) {
        msnry = new Masonry(minisiteIdeas.get(0), {
            'itemSelector': '.sv-minisite-idea',
            'columnWidth': 220,
            'gutter': 5,
            'isFitWidth': true
        });
        minisiteIdeas.infinitescroll({
            navSelector: '.sv-ideas__nav',
            nextSelector: '.sv-ideas__nav link[rel=next]',
            itemSelector: '.sv-minisite-idea',
            appendCallback: false,
            maxPage: minisiteIdeas.data('maxPage')
        }, function (elems) {
            $.each(elems, function(index, elem) {
                minisiteIdeas.append(elem);
                $(elem).find('img').on('load', function() {
                    $(elem).removeClass('sv-idea_hidden');
                    msnry.appended(elem);
                })
            });
        });

    }

  new ColorSearchForm({
    'input': '.sv-ideas__search-form [data-js=idea-search-input]',
    'colorInput': '.sv-ideas__search-form .sv-color-tag__checkbox',
    'tagList': '.sv-ideas__search-form [data-js=idea-search-taglist]',
    'immediate': true
  });

  new ColorSearchForm({
    'input': '[data-js=header-color-search] [data-js=idea-search-input]',
    'colorInput': '[data-js=header-color-search] .sv-color-tag__checkbox',
    'tagList': '[data-js=header-color-search] [data-js=idea-search-taglist]',
    'immediate': true
  });
});
