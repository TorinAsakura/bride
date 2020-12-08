function deleteSpaces (str) {
  str = str.replace(/\s/g, '');
  return str;
}

function isNumeric(n) {
  n = n.replace(',', '.');
  return !isNaN(parseFloat(n)) && isFinite(n);
}

function addErrorMessage (item, value, className) {
  errorMessage = '"'+ value +'" не является числом';
  item.addClass('error-'+className);
  className = className || 'errorName'
  item.children('.error-message.'+className).text(errorMessage);
}

function removeErrorMessage (item, className) {
  item.removeClass('error-'+className);
  className = className || 'errorName'
  item.children('.error-message.'+className).text('');
}

function getNumber (element, className) {
  className = className || 'error';
  var number = element.val().trim().replace(',', '.');

  var item = $( element.parents('.item') );

  if (isNumeric(number) || number === '') {
    result = +number;
    result = result.toFixed(2);
    removeErrorMessage(item, className);
  } else {
    result = 0.00;
    addErrorMessage(item, number, className);
  }

  return result;
}

function formatNumeric(nStr) {
  nStr = parseFloat(nStr);
  nStr = nStr.toFixed(2);

  nStr += '';
  x = nStr.split('.');
  x1 = x[0];

  x2 = x.length > 1 ? '.' + x[1] : '.00';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ' ' + '$2');
  }
  return x1 + x2;
}

defaultItem = { 'name': 0, 'price': 0, 'count': 1, 'ui': 'шт.', 'countReadOnly': '' };

function addItem (categoryItems, item) {
  item = $.extend({}, defaultItem, item);

  var itemHTML = '\
    <div class="item">\
      <div class="error-message price"></div>\
      <div class="error-message count"></div>\
      <div class="name">'+ item.name +'</div>\
      <div class="item-price" title="Цена за единицу">\
        <input class="item-price" type="text" value="'+ item.price +'">\
        <span> руб.</span>\
      </div>\
      <div class="item-count" title="Количество">\
        <input class="item-count" type="text" value="'+ item.count +'" '+ item.countReadOnly +'>\
        <span class="item-iu"> '+ item.iu +' </span>\
      </div>\
      <div class="item-total" title="Сумма">\
        <span class="total-price"> '+ formatNumeric(item.totalPrice) +' </span>\
        <span> руб. </span>\
      </div>\
      <div class="delete" title="Удалить">\
        <span class="icon delete">удалить</span>\
      <div class="clear"></div>\
    </div>\
  ';
  categoryItems.append(itemHTML);
}

function addCategories (categories) {
  $.each(categories, function(){
    categoryData = this;
    categoryHTML = '\
      <div class="calc-category '+ categoryData.type +'" type="'+categoryData.type+'">\
        <div class="icon plus"></div>\
        <div class="title">'+ categoryData.name +'</div>\
        <div class="category-total-price"><span class="price">'+ formatNumeric(categoryData.price) +'</span> руб.</div>\
        <div class="items" style="display: none;"></div>\
      </div>\
    ';
    $('.calc-categories').append(categoryHTML);
    categoryItems = $('.calc-category.'+ categoryData.type +' .items');
    $.each(categoryData.items, function(){
      item = this;
      addItem (categoryItems, item)
    });
  });
};

function categoryTotalPrice (category) {
  totalPrices = category.children().children().children().children('.total-price');
  var totalPrice = 0;
  $.each(totalPrices, function(){
    price = $(this).text().trim();
    price = deleteSpaces(price);
    price = +price;
    totalPrice += price;
  });
  category.children().children('span.price').text( formatNumeric(totalPrice) );
}

function allCategoriesTotalPrice () {
  totalPrices = $('.category-total-price span.price');
  var totalPrice = 0;
  $.each(totalPrices, function(){
    price = $(this).text();
    price = deleteSpaces(price);
    price = +price;
    totalPrice += price;
  });
  $('.all-categories-total-price span.price').text( formatNumeric(totalPrice) );
}

function initCategories () {
  $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/wedding_calcs/'+ $('#main-container-wedding-calc').attr('wedding_calc_id') +'/get_data',
    {},
    function(data, textStatus) {
      if(data.categories != undefined ) {
        categories = $.parseJSON(data.categories);

        addCategories(categories);
      } else {
        addCategories (categoriesStart);
      }

      allCategoriesTotalPrice();
    }
  );
}

function dataToSave () {
  var categories = [];

  $.each($('.calc-category'), function(){
    var category = $(this);
    var itemsData = [];

    $.each(category.children('.items').children('.item'), function() {
      var item = $(this);
      readonly = ( item.children().children('.item-count').attr('readonly') == 'readonly' ) ? 'readonly' : '';

      var itemPrice = deleteSpaces( item.children().children('input.item-price').val() );
      var itemCount = deleteSpaces( item.children().children('input.item-count').val() );
      var itemTotalPrice = deleteSpaces( item.children().children('span.total-price').text() );

      var itemResult = {
        'name'           : item.children('.name').html(),
        'price'          : itemPrice,
        'count'          : itemCount,
        'countReadOnly'  : readonly,
        'iu'             : item.children().children('span.item-iu').text(),
        'totalPrice'     : itemTotalPrice,
      }

      itemsData.push(itemResult);
    });

    var categoryPrice = deleteSpaces( category.children('.category-total-price').children('.price').text() );

    var categoryResult = {
      'type': category.attr('type'),
      'name': category.children('.title').html(),
      'price': categoryPrice,

      'items': itemsData,
    }
    categories.push(categoryResult);
  });
  return categories;
}

saveWeddingCalcData = function () {
  var data = dataToSave();
  $.post(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/wedding_calcs/'+ $('#main-container-wedding-calc').attr('wedding_calc_id') +'/save_data',
    {
      categories: JSON.stringify( data ),
    },
    function(data, textStatus) {
      if(data.result == 'saved') {
        alert('Данные успешно сохранены');
      } else {
        alert('Во время сохранения произошел сбой, пожалуйста повторите сохранение данных');
      }
    }
  );

  return false;
}

weddingCalcShowModalAddItem = function () {
  $('#modal-add-item input').val('');
  $('#modal-add-item input.modal-item-iu').val('шт.');

  $('#edit').html($('#modal-add-item'));
  $('#edit .modal').modal('show');
  return false;
}

weddingCalcAddItem = function () {
  var item = {}
  item.name = $('.modal-item-name').val().trim();
  item.iu = $('.modal-item-iu').val().trim();

  $.fancybox.close();

  if ( item.name != '' && item.iu != '') {
    categoryItems = $('.calc-category'+ $('.modal-category').val() + ' .items');
    addItem (categoryItems, item);
  }
  return false;
}

 var categoriesStart = [
      {
        'type': 'bride',
        'name': 'Невеста',
        'price': '0',
        'items': [
          {'name':'Фата',                         'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Перчатки',                     'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'пара',   'totalPrice':0},
          {'name':'Сумочка',                      'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Нижнее белье',                 'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'комлп.', 'totalPrice':0},
          {'name':'Чулки',                        'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'пара.',  'totalPrice':0},
          {'name':'Нижняя юбка (кринолин)',       'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Туфли',                        'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'пара',   'totalPrice':0},
          {'name':'Накидка на плечи или шуба',    'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Бижутерия',                    'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Цветочки для прически, венок', 'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Платье на 2-й день',           'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'groom',
        'name': 'Жених',
        'price': '0',
        'items': [
          {'name':'Костюм',                         'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Рубашка',                        'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Бабочка и галстук',              'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Туфли',                          'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'пара.',  'totalPrice':0},
          {'name':'Нижнее белье',                   'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'комлп.', 'totalPrice':0},
        ],
      },
      {
        'type': 'rings',
        'name': 'Кольца',
        'price': '0',
        'items': [
          {'name':'Кольцо невесты',                 'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Кольцо жениха',                  'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'wedding',
        'name': 'Бракосочетание / Венчание',
        'price': '0',
        'items': [
          {'name':'Регистрация брака',              'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Венчание',                       'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Атрибуты для венчания',          'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'комлп.', 'totalPrice':0},
          {'name':'Музыкальное сопровождение',      'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name':'Фотосъемка',                     'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
          {'name':'Видеосъемка',                    'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'accessories',
        'name': 'Аксессуары',
        'price': '0',
        'items': [
          {'name':'Бокалы для молодоженов',                         'price':0, 'count':2, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Ленты или бутоньерки для свидетелей',            'price':0, 'count':2, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Кольца и ленты на машину',                       'price':0, 'count':1, 'countReadOnly':'', 'iu':'комлп.', 'totalPrice':0},
          {'name':'Нож и лопатка для свадебного торта',             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Бантики на бокалы',                              'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Стаканчики для гостей',                          'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Корзинка для бутербродов',                       'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Ленты для связивания шампанского',               'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name':'Гостевая книга и ручка (для пожеланий гостей)',  'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'the_wedding_banquet',
        'name': 'Свадебный банкет',
        'price': '0',
        'items' : [
          {'name': 'Аренда зала',                             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Меню на одного человека',                 'price':0, 'count':1, 'countReadOnly':'', 'iu':'чел.',   'totalPrice':0},
          {'name': 'Спиртные напитки',                        'price':0, 'count':1, 'countReadOnly':'', 'iu':'бут.',   'totalPrice':0},
          {'name': 'Шампанское',                              'price':0, 'count':1, 'countReadOnly':'', 'iu':'бут.',   'totalPrice':0},
          {'name': 'Прохладительные напитки',                 'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Свадебный торт',                          'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Каравай',                                 'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Фрукты',                                  'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'printed_matter',
        'name': 'Печатная продукция',
        'price': '0',
        'items' : [
          {'name': 'Пригласительные открытки',                'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Карточки для гостей',                     'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'flowers_and_balloons',
        'name': 'Цветы и шарики',
        'price': '0',
        'items' : [
          {'name': 'Букет невесты',                           'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Бутоньерка жениха',                       'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Украшение автомобиля',                    'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
          {'name': 'Цветы для украшения зала',                'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
          {'name': 'Шарики',                                  'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'photos_and_video',
        'name': 'Фото и видеосъемка',
        'price': '0',
        'items' : [
          {'name': 'Услуги фотографа',                        'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Услуги видеооператора',                   'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Монтаж фильма',                           'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Стоимость фотоальбома',                   'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Фотопленка',                              'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Видеопленка',                             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'master_of_ceremonies_and_music',
        'name': 'Тамада и музыка',
        'price': '0',
        'items' : [
          {'name': 'Ведущий свадьбы',                         'price':0, 'count':1, 'countReadOnly':'', 'iu':'чел.',   'totalPrice':0},
          {'name': 'Живая музыка',                            'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Дискотека',                               'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'transport',
        'name': 'Транспорт',
        'price': '0',
        'items' : [
          {'name': 'Аренда авто для молодоженов',             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Аренда авто для гостей',                  'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Аренда автобуса',                         'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Аренда авто для новобрачных (вечером)',   'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'makeup',
        'name': 'Прическа, макияж и маникюр',
        'price': '0',
        'items' : [
          {'name': 'Прическа невесты',                        'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Прическа жениха',                         'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Макияж невесты',                          'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Маникюр невесты',                         'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Маникюр жениха',                          'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'tour',
        'name': 'Прогулка',
        'price': '0',
        'items' : [
          {'name': 'Голуби',                                  'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Спиртное на прогулку',                    'price':0, 'count':1, 'countReadOnly':'', 'iu':'бут.',   'totalPrice':0},
          {'name': 'Деньги на непридвиденный случай',         'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'honeymoon',
        'name': 'Свадебное путешествие',
        'price': '0',
        'items' : [
          {'name': 'Тур путёвка',                             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Билеты',                                  'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Деньги в поездку',                        'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'the_wedding_night',
        'name': 'Первая брачная ночь',
        'price': '0',
        'items' : [
          {'name': 'Номер для молодоженов',                   'price':0, 'count':1, 'countReadOnly':'readonly', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Свечки',                                  'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
          {'name': 'Ароматические палочки',                   'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
          {'name': 'Шампанское',                              'price':0, 'count':1, 'countReadOnly':'',         'iu':'бут.',    'totalPrice':0},
          {'name': 'Cексуальное бельё',                       'price':0, 'count':1, 'countReadOnly':'',         'iu':'шт.',    'totalPrice':0},
        ],
      },
      {
        'type': 'the_last_chord',
        'name': 'Последний аккорд',
        'price': '0',
        'items' : [
          {'name': 'Фейерверк',                               'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Запуск шаров',                            'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
          {'name': 'Сброс шаров',                             'price':0, 'count':1, 'countReadOnly':'', 'iu':'шт.',    'totalPrice':0},
        ],
      },
    ];

$(document).ready(function(){
  if ( $('#main-container-wedding-calc').length != 0 ) {

    initCategories();

    // элемент, который должен «прилепляться» к краю окна
    var menu = $('#calc-top-menu');
    var menuClone = $('#calc-top-menu-clone');

    // задаём отступ от края окна браузера, если не хочется чтобы элемент прилеплялся вплотную к границе окна
    var margin = 0;
    var padding = parseInt($(menu).css("padding-left"), 10) + parseInt($(menu).css("padding-right"), 10);
    var menuWidth = $(menu).width() + padding;
    // при каком кол-ве «прокрученных пикселей» элемент должен «прилепляться» к окну
    var borderY = menu.offset().top - margin;

    // обработчик будет вызывать постоянно в процессе прокрутки документа
    $(window).on('scroll', function() {
      // запоминаем на сколько пикселей сейчас прокручен документ
      var currentY = $(document).scrollTop();

      if(currentY > borderY)
      {
        // пора «вырывать» элемент из документа и прилеплять его к окну для этого присваиваем его свойствам CSS
        menu.css({position: 'fixed', top: margin + 'px', width: menuWidth + 'px'});
        // так как меню "вырвано" из документа, происходит резкий рывок документа на его место, поэтому присваиваем для псевдо-меню высоту основного меню
        menuClone.css({height: '50px'});
      }
      else if(currentY < borderY)
      {
        // теперь пользователь прокрутил окно обратно вверх, пора вернуть элемент на исходное место;
        // для этого возвращаем изменённые значения свойств CSS к изначальным
        menu.css({position: '', top: '', width:'', 'border-bottom':''});
        menuClone.css({height: ''});
      }
    });

    $(document).on('change', '.item-price', function(el){
      var priceEl = $(el.target);
      var countEl = $(el.target).parents('.item').children('.item-count').children('input');

      categoryType = priceEl.parents('.calc-category').attr('type');
      category = $('.'+categoryType);
      categoryTotalPrice (category);

      price = getNumber(priceEl, 'price');
      count = getNumber(countEl, 'count');

      totalPrice = price * count;

      $( priceEl.parent().parent().children('.item-total').children('span.total-price') ).text( formatNumeric(totalPrice) );
      allCategoriesTotalPrice();
    });

    $(document).on('change', '.item-count', function(el){
      var countEl = $(el.target);
      var priceEl = $(el.target).parents('.item').children('.item-price').children('input');

      categoryType = priceEl.parents('.calc-category').attr('type');
      category = $('.'+categoryType);
      categoryTotalPrice (category);

      price = getNumber(priceEl, 'price');
      count = getNumber(countEl, 'count');

      totalPrice = price * count;

      $( priceEl.parent().parent().children('.item-total').children('span.total-price') ).text( formatNumeric(totalPrice) );
      allCategoriesTotalPrice();
    });

    $(document).on('click', '.item .delete', function(el){
      var item = $(el.target).parents('.item');
      item.addClass('delete-select');

      if ( confirm( 'Удалить позицию "'+item.children('.name').text()+'"?') ) {
        category = item.parents('.calc-category')

        item.hide("puff", { percent: 500 }, 600);
        setTimeout(function() { item.remove(); }, 700);

        categoryTotalPrice (category);
        allCategoriesTotalPrice();
      } else {
        item.removeClass('delete-select');
      };
      return false;
    });

    $(document).on('click', '.icon.plus', function(el){
      var categotyItems = $(el.target).parent().children('.items');
      categotyItems.show('blind', {}, 500);

      $(el.target).removeClass('plus');
      $(el.target).addClass('minus');
    });

    $(document).on('click', '.icon.minus', function(el){
      var categotyItems = $(el.target).parent().children('.items');
      categotyItems.hide('blind', {}, 500);

      $(el.target).removeClass('minus');
      $(el.target).addClass('plus');
    });
  }
});
