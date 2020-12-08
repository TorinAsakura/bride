# encoding: utf-8
require 'csv'

namespace :seeds do
  
  task add_firm_catalog_items: :environment do
    FIRM_CATALOG_ITEMS.each do |fci|
      fc = FirmCatalog.create(name: fci[:name])
      fci[:items].each { |i| fc.firm_catalogs << FirmCatalog.new(name: i) }
    end
  end

  task generate_slug_for_firms: :environment do
     Firm.where(slug: nil).each do |firm|
      firm.generate_slug
      firm.save
    end   
  end

  task test_task: :environment do
    TaskCategory.destroy_all ; Task.destroy_all ; Script.destroy_all ; Plan.destroy_all
    #create script for 15 weeks
    tc = TaskCategory.create(name: 'Пробные таски')
    firm_catalog = FirmCatalog.where('parent_id is not null').first
    [15].each do |week_index|
      s = Script.create(name: "#{week_index} недель скрипт",
                        description: "Это пробный скрипт на #{week_index} недель",
                        weeks: week_index)
      s.plans.each_with_index do |plan, index|

        task1 = Task.create(name: "Простая задача #{index}#{rand(1000)}", 
                            description: "Это обычная простая задача #{index}",
                            task_category_id: tc.id, type_task: 'simply')
        task1.tag_list.add('tagaz')
        task1.firm_catalogs << firm_catalog.parent << firm_catalog
        task1.save
        plan.tasks << task1
        task2 = Task.create(name: "Задача с сервисом #{index}#{rand(1000)}",
                            task_category_id: tc.id,
                            type_task: 'with_service', service: 'service_1')
        task2.tag_list.add('tagaz')
        task2.firm_catalogs << firm_catalog.parent << firm_catalog
        task2.save
        plan.tasks << task2
        task3 = Task.create(name: "Задача совет #{index}#{rand(1000)}",
                            description: "Это задача совет #{index}",
                            task_category_id: tc.id, type_task: 'advice')
        task3.tag_list.add('tagaz')
        task3.firm_catalogs << firm_catalog.parent << firm_catalog
        task3.save
        plan.tasks << task3
      end
    end
  end

  task clear_weddings: :environment do
    Wedding.destroy_all ; Timetable.destroy_all ; Event.destroy_all
    Client.all.each{|c| c.update_attributes(wedding_id: nil, couple_id: nil)} 
  end

  task city_to_database: :environment do
    if 0 === City.count
      russia = Country.where(name: 'Россия').first_or_create!
      seed_cities_and_regions_from_csv(russia)
    end

    City.where('name SIMILAR TO ?', "\t%").each do |city|
      city.name = city.name.strip
      city.save
    end

    Region.where('name SIMILAR TO ?', "\t%").each do |region|
      region.name = region.name.strip
      region.save
    end
    puts 'names of cities and regions has striped'

    Client.all.each { |c| c.build_avatar_image; c.save }
    Photo.all.each { |p| p.usual_path.recreate_versions!(:large_preview); p.save! }

    remove_duplicate_cities
    wedding_cities_from_csv

    Role.where(resource_type: :Album).destroy_all
    Role.where(resource_type: :MediaContent).destroy_all
  end
end

desc 'run all seeds'
task seeds: :environment do
  Rake::Task['seeds:add_firm_catalog_items'].invoke
  Rake::Task['seeds:generate_slug_for_firms'].invoke
  Rake::Task['seeds:test_task'].invoke
  Rake::Task['seeds:clear_weddings'].invoke
  Rake::Task['seeds:city_to_database'].invoke
end


#functions
def seed_cities_and_regions_from_csv(default_country)
  puts default_country.inspect
  regions = {}
  CSV.foreach('db/csv/regions.csv', :col_sep => ";") do |row|
    regions[row[0].to_i] = Region.where(name: row[1].strip).first_or_create! do |r|
      r.country = default_country
    end
  end

  CSV.foreach('db/csv/cities.csv', :col_sep => ";") do |city|
    City.create!(name: city[1].strip, region_id: regions[city[2].to_i].id)
  end
end

def remove_duplicate_cities
  cities = City.order :id
  uniqunes_cities = []

  count_removed_cities = 0
  cities.each do |city|
    if uniqunes_cities.include?(city.name)
      count_removed_cities +=1
      city.destroy
    else
      uniqunes_cities.push(city.name)
    end
  end
  puts 'cities.count='+cities.count.to_s
  puts 'uniqunes_cities.count='+uniqunes_cities.count.to_s
  puts "#{count_removed_cities} duplicated #{(count_removed_cities>1 ? 'cities' : 'city')} has removed from DB"
end

def wedding_cities_from_csv
  i = 0
  p 'City before count='+City.count.to_s
  CSV.foreach('db/csv/wedding_cities.csv') do |special_city|
    city = City.find_by_name special_city
    if city.blank?
      puts "did not find #{special_city}"
    elsif false === city.wedding_city
      city.update_attribute('wedding_city', true)
      i +=1
    end
  end
  p 'City after count='+City.count.to_s
  puts "#{i} #{(i>1 ? 'cities' : 'city')} has marked by wedding_city flag"
end

FIRM_CATALOG_ITEMS = [
  {
    name: 'Аксессуары для свадьбы',
    items: ['Оформление свадебных аксессуаров', 'Свадебные аксессуары']
  },
  {
    name: 'Банкет',
    items: [
      'Базы отдыха и усадьбы', 'Кафе и бары', 'Кейтеринг', 'Напитки для застолья',
      'Рестораны и Банкетные залы', 'Столовые', 'Торты'
    ]
  },
  {
    name: 'Видеосьемка',
    items: [
      'Видео-презентации',
      'Видеографы',
      'Видеомонтаж',
    ]
  },
  {
    name: 'Консультации',
    items: [
      'Астрологические',
      'Банки',
      'Медицинские',
      'Психологическая консультация',
      'Юридические'
    ]
  },
  {
    name: 'Мастера красоты',
    items: [
      'Визаж и макияж',
      'Здоровое тело, массаж, диетология',
      'Имидж',
      'Маникюр и педикюр',
      'Прическа'
    ]
  },
  {
    name: 'Мужские костюмы',
    items: [
      'Костюмы для свидетелей',
      'Модельеры',
      'Мужские костюмы',
      'Обувь',
      'Прокат нарядов'
    ]
  },
  {
    name: 'Организаторы',
    items: [
      'Агенства',
      'Выездная регистрация брака',
      'Организаторы'
    ]
  },
  {
    name: 'Оформление залов',
    items: [
      'Декорирование тканями',
      'Оформление цветами',
      'Украшение воздушными шарами'
    ]
  },
  {
    name: 'Подарки',
    items: [
      'Интернет-магазины',
      'Магазины подарков',
      'Оформление подарков'
    ]
  },
  {
    name: 'Приглашения',
    items: [
      'Карточки гостей',
      'Открытки поздравительные',
      'Приглашения на свадьбу'
    ]
  },
  {
    name: 'Прокат оборудования',
    items: [
      'Видео оборудование',
      'Генераторы бензиновые',
      'Звуковое оборудование',
      'Световое оборудование',
      'Спецэффекты'
    ]
  },
  {
    name: 'Развлечь гостей',
    items: [
      'Ансамбли и музыкальные группы',
      'Бармен-шоу',
      'Музыканты',
      'Огненное (Fire-show) и световое шоу',
      'Пародисты',
      'Певцы и Вокал',
      'Песочное шоу',
      'Пирамиды из бокалов с шампанским',
      'Танцевальные коллективы',
      'Фокусники и Иллюзионисты',
      'Художники',
      'Цирковые артисты и шоу',
      'Шоу мыльных пузырей',
      'Юмористы'
    ]
  },
  {
    name: 'Салют на свадьбу',
    items: [
      'Салют из Бабочек',
      'Голуби',
      'Небесные фонарики',
      'Фейерверки'
    ]
  },
  {
    name: 'Свадебное путешествие',
    items: [
      'Базы отдыха',
      'Гостиницы',
      'Турфирмы'
    ]
  },
  {
    name: 'Свадебные платья',
    items: [
      'Модельеры',
      'Наряды для подружек невесты и мам',
      'Нижнее белье',
      'Обувь для невест',
      'Прокат нарядов',
      'Свадебные платья'
    ]
  },
  {
    name: 'Свадебный танец',
    items: [
      'Частные преподаватели',
      'Школы танцев'
    ]
  },
  {
    name: 'Свадьба за границей',
    items: [
      'Event агентства',
      'Всё под ключ',
      'Туроператоры'
    ]
  },
  {
    name: 'СМИ для молодоженов',
    items: [
      'Выставки',
      'Журналы',
      'ЗАГСы',
      'Знакомства',
      'Молодожены',
      'Обустройство дома',
      'Свадебные сайты'
    ]
  },
  {
    name: 'Тамада, ведущие',
    items: [
      'Ведущий и тамада',
      'Деды морозы и снегурочки',
      'Диджеи (Dj)',
      'Чревовещатели'
    ]
  },
  {
    name: 'Транспорт',
    items: [
      'Трамваи',
      'Автобусы',
      'Внедорожники и кроссоверы',
      'Кареты',
      'Легковые автомобили',
      'Летательные аппараты',
      'Лимузины',
      'Лошади',
      'Микроавтобусы и минивэны',
      'Мотоциклы, мопеды и квадроциклы',
      'Ретро автомобили',
      'Теплоходы',
      'Украшения машин'
    ]
  },
  {
    name: 'Фотосъемка',
    items: [
      'Студийная съемка',
      'Фотоальбомы',
      'Фотографы',
      'Фотопечать'
    ]
  },
  {
    name: 'Цветы',
    items: [
      'Букет невесты',
      'Букеты для гостей',
      'Бутоньерки'
    ]
  },
  {
    name: 'Ювелирные украшения',
    items: [
      'Обручальные кольца',
      'Серьги',
      'Цепочки'
    ]
  }
]
