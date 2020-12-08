# encoding: utf-8

#minisite
MINISITE_SYSTEM_PAGES = [
  {
    name:    'about',
    title:   'О нас',
    content: 'Отредактируйте эту информацию в панели управления',
    active:  true,
    main:    true,
    hidden:  false
  }, {
    name:    'albums',
    title:   'Фотогалерея',
    content: 'Отредактируйте эту информацию в панели управления',
    active:  true,
    main:    false,
    hidden:  true
  }
]

MINISITE_PRIVACY = [['Доступ без пароля', 0], ['Доступ по паролю', 1]]

#client profile
CLIENT_SIDEBAR_ALBUMS = 2
CLIENT_SIDEBAR_FRIENDS = 6
CLIENT_SIDEBAR_VIDEOS = 2
CLIENT_PHOTO_PREVIEWS = 5
CLIENT_POSTS_PREVIEWS = 7
CLIENT_TIMEOUT_MINUTES = 15
#edit client
CLIENTS_ON_CURRENT_WEEK = 6

#wedding
EVENT_COUNT_IDEAS = 8
EVENT_COUNT_POSTS = 6
EVENT_COUNT_VIDEO = 4
EVENT_COUNT_FIRMS = 6
EVENT_COUNT_IDEAS_PAGE = 16
EVENT_COUNT_POSTS_PAGE = 10
EVENT_COUNT_VIDEO_PAGE = 10

#client setting
LIFE_POSITION = ['Не указано','Резко против','Негативное','Компромиссное','Нейтральное','Положительное']
THING_IN_LIFE = ['Не указано','Семья и дети','Бизнес и карьера','Развлечения и отдых','Наука и исследования',
                 'Совершенствование мира','Саморазвитие','Искусство и красота','Популярность и влияние']
THING_IN_HUMANS = ['Не указано','Ум и креативность','Доброта и честность','Красота и здоровье',
                   'Власть и богатство','Смелость и упорство','Юмор и жизнелюбие']
CLIENT_PAGE_VISIBILITY = ['Всем','Друзьям','Никому']
CLIENT_MARITAL_STATUS = ['Встречаемся','Помолвлены','Всё сложно','В активном поиске']
MALE_CLIENT_MARITAL_STATUS =  ['Холостой','Женат','Влюблен'] + CLIENT_MARITAL_STATUS
FEMALE_CLIENT_MARITAL_STATUS = ['Не замужем','Замужем','Влюблена'] + CLIENT_MARITAL_STATUS
CLIENT_CHILDREN = ['Нет','1 ребёнок','2 ребёнка','3 ребёнка','4 и более']

#homepage
HOMEPAGE_POSTS = 12
HOMEPAGE_VIDEOS = 4
HOMEPAGE_CLIENTS = 16
HOMEPAGE_SITES = 4

#community
COMMUNITY_RANDOM_CLIENTS = 15

#firm
FIRM_SERVICES_COUNT = 15
