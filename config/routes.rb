ChelnySvadba::Application.routes.draw do
defaults subdomain: '' do

  post "votes/like"
  delete "votes/unlike"

  match '/auth/:provider/callback' => 'authorizations#create'
  resources :authorizations, :only => [:index, :create, :destroy]
  match '/auth/failure' => 'authorizations#auth_failure'

  resources :competitions, :only => :index do
    resources :albums do
      resources :photos
    end
    member do
      get 'detail'
    end
    collection do
      get 'like_album'
      get 'unlike_album'
    end
  end

  resources :polls, only: [:index, :new, :create, :show, :destroy] do
    get :instagram_photos, on: :collection
    get :vkontakte_photos, on: :collection
  end

  resources :vkontakte_media, :path_names => {:index => 'albums', :show => 'album'} do
    get 'download', on: :collection
    get 'validate_session', on: :collection
  end

  resources :instagram_media, only: [:index] do
    get 'download', on: :collection
    get 'validate_session', on: :collection
  end

  scope '/city' do
    get 'autocomplete', :to => 'cities#autocomplete', :as => 'city_autocomplete'
    post 'update', :to => 'cities#update', :as => 'city_update'
  end

  resource :dealer, only: [] do
    get :new_transfer_to_system
    post :transfer_to_system
  end

  constraints(Subdomain) do
    get 'albums' => 'subdomains#albums'
    get "/albums/:album_id" => 'subdomains#show_album', constraints: { album_id: /[0-9]+/ }
    get '/' => 'subdomains#show'

    resources :complaints, only: [ :new, :create ]
    resources :favorites, only: [:index, :create, :destroy]

    resources :albums, except: [:index, :show] do
      resources :photos
      post 'upload_photo', on: :member
    end

    resources :posts, except: [:index, :update, :create] do
      member do
        post :accept
        post :refuse
      end
    end
    resources :firms do
      resources :posts,  only: [:update, :new, :create]
      resources :videos, only: [:update]
    end

    namespace :bonus do
      resources :services, only: [:index] do
        resources :subscriptions, only: [:new, :create]
      end
    end


    resources :posts, only: [] do
      resources :images, only: [ :create, :show, :destroy ], controller: :attachment_images
    end


    resources :messages do
      get :append, on: :member
      get 'new/:user_id' => 'messages#new', as: :new, on: :collection
      resources :images, only: :create, controller: :attachment_images
    end

    resources :videos, except: [:index] do
      member do
        post :accept
        post :refuse
      end
    end

    resources :comments, only: [ :create, :show, :update, :destroy ] do
      resources :images, only: [ :create, :show, :destroy ], controller: :attachment_images
    end
    post "accept_friendship/:id" => "friendship#accept_friendship", :as => :accept_friendship
    post "deny_friendship/:id"   => "friendship#deny_friendship",   :as => :deny_friendship
    post "add_to_my_friends/:id" => "friendship#add_to_my_friends", :as => :add_to_my_friends
    post "remove_friendship/:id" => "friendship#remove_friendship", :as => :remove_friendship

    resource :dealer, only: :show

    resources :firm_comments, only: [ :create, :destroy ]
  end

  scope module: :firms, as: :firm do
    constraints(Subdomain) do

      delete 'destroy_logo'
      delete 'destroy_banner/:banner_id', action: :destroy_banner, constraints: { banner_id: /[0-9]+/ }, as: :destroy_banner

      get 'pages/:firm_page_id', action: 'show_page', constraints: { album_id: /[0-9]+/ }, as: :page
      get 'videos'
      get 'posts', as: :posts_page
      get 'addresses'
      get 'comments', as: :comments_page
      get 'customers'

      get '/albums/:album_id/photos/:id' => 'photos#show', as: :album_photo
      # end of firm site
    end
  end

  scope module: :minisite, as: :minisite do
    constraints(Subdomain) do
      # get 'plan_of_measures' => 'minisites#plan_of_measures', as: :plan_of_measures

      resources :promises, only: [:create, :destroy]

      resources :albums, path: '/album', except: [:index] do
        member do
          post 'upload_photo'
          put  'upload_photo'
        end
      end
      get 'albums', as: :all_albums

      resources :images, :only => [:show]

      resources :guestbooks, :only => [:index, :create, :destroy]

      # start of wedding services



        get 'wedding_calc' => 'wedding_calcs#index', as: :wedding_calc
        resources :wedding_calcs, only: :index do
          get  'get_data'
        end

        get 'wish_list' => 'wishlists#index', as: :wishlists

        get 'wedding_program' => 'programms#index', as: :wedding_program
        get 'second_day_program' => 'programms#index', defaults: {second_day: true}, as: :second_day_program

      # end of wedding services

      resource :seating_plan, only: [:show] do
        get  'get_data'
      end

      namespace :seating do
        root to: 'plans#show'
        resource :plan, only: [:show, :edit] do
          resources :tables, only: [:create, :update, :destroy] do
            resources :seats, only: [:create, :update, :destroy]
          end
        end
      end

      resources :guests, except: [:new] do
        post 'confirm(/:status)' => 'guests#confirm', as: :confirm, on: :member, constraints: {status: /#{Guest::STATUSES.join('|')}/}
        collection do
          get 'new(/:group)' => 'guests#new', as: :new, constraints: {group: /#{Guest::GROUPS.join('|')}/}
          post 'sort(/:group)' => 'guests#sort', as: :sort, constraints: {group: /#{Guest::GROUPS.join('|')}/}
        end
      end

      resource :events, only: [:index] do
        get :man
        get :woman
      end

      namespace :my_ideas do
        root to: 'ideas#index'
        resources :categories, only: :show do
          resources :ideas, only: :show
        end
        resources :ideas, only: [:index, :show] do
          post :cover
        end
      end

      post 'code'     => 'minisites#code'
      match '/:page'  => 'minisites#page', as: :page
      match '*rest'   => 'minisites#page_404'
    end
  end

  get 'minisites' => 'sites#index', as: :all_minisites
  resources :sites, except: :index do
    resources :albums do
      resources :photos
    end
    resources :pages
    resources :guestbooks

    get 'check_name_present', on: :collection

    member do
      put :update_address
      put :update_base_settings
    end

    # start of wedding services
      get 'edit_wedding_calc' => 'wedding_calcs#edit_calc', as: :edit_wedding_calc
      get 'wedding_calc' => 'wedding_calcs#index', as: :wedding_calc

      resources :wishlists, except: :index do
        put 'update_all', on: :collection
      end
      get 'edit_wish_list' => 'wishlists#edit_wishlist', as: :edit_wish_list
      get 'wish_list' => 'wishlists#index', as: :wish_list

      resources :programms, except: :index
      get 'edit_wedding_program' => 'programms#edit_program', as: :edit_wedding_program
      get 'wedding_program' => 'programms#index', as: :wedding_program

      resources :programms_second, except: :index, controller: 'programms', defaults: {second_day: true}
      get 'edit_second_day_program' => 'programms#edit_program', defaults: {second_day: true}, as: :edit_second_day_program
      get 'second_day_program' => 'programms#index', defaults: {second_day: true}, as: :second_day_program

    # end of wedding services
  end

  resources :wedding_calcs, except: :all do
    get  'get_data'
    post 'save_data'
  end

  root to: 'home#index'

  devise_for :users, controllers: {
      registrations: 'users/registrations',
      invitations: 'users/invitations',
      passwords: 'users/passwords',
      sessions: 'users/sessions',
      confirmations: 'users/confirmations'
    }

  match 'wedding_start' => 'home#wedding_start'
  match 'city_search'   => 'home#city_search'
  match 'search'        => 'home#search'
  match 'tags'          => 'home#tags'
  match 'regions/:id'   => 'home#regions'
  match 'cities/:id'    => 'home#cities'

  post "add_to_my_friends/:id" => "friendship#add_to_my_friends", :as => :add_to_my_friends
  post "accept_friendship/:id" => "friendship#accept_friendship", :as => :accept_friendship
  post "deny_friendship/:id"   => "friendship#deny_friendship",   :as => :deny_friendship
  post "remove_friendship/:id" => "friendship#remove_friendship", :as => :remove_friendship

  namespace :idea do
    root to: 'sections#index'
    resources :sections, only: [:index, :show] do
      resources :categories, only: :show do
        resources :ideas, only: [:show, :edit, :update]
      end
    end
    resources :ideas, except: [:new, :create] do
      post :add, on: :member
      delete :remove, on: :member

      post :cover, on: :collection
    end

    get '/:color' => 'ideas#index', as: 'color', constraints: {color: /#{Tag::COLORS.values.join('|')}/}
  end

  resources :images, :only => [:show]

######################## ADMIN NAMESPACE #########################
  match "/admin" => redirect("/admin/firms")

  scope '/admin' do
    get 'firms/:firm_id/videos/:id' => 'videos#show', as: :admin_firm_video
    get 'clients/:client_id/videos/:id' => 'videos#show', as: :admin_client_video
    get 'firms/:firm_id/posts/:id' => 'posts#show', as: :admin_firm_post
    get 'clients/:client_id/posts/:id' => 'posts#show', as: :admin_client_post
  end

  namespace :admin do
    resources :firms, except: [:show, :new, :create] do
      get '/:type/list', to: :index, on: :collection, as: :select
      get :dealer, on: :member
    end

    resources :t_firms, exept: [:show, :new, :edit, :create]

    resources :firm_catalogs, except: :show do
      collection do
        post :rebuild
        post :expand_node
        get :expand_node
      end
    end

    resources :purses, only: [:show, :edit, :update] do
      member do
        get :new_cash_deposit
        post :cash_deposit
        get :new_admin_deposit
        post :admin_deposit
      end
      resources :purse_payments, only: [:index, :show]
    end

    resources :purse_payments, only: [:index, :show]
    namespace :bonus do
      resources :services, except: :show do
        post :sort, on: :collection
        resources :prices, only: :index do
          put '/:firm_catalog_id', to: :update_price, as: :update_price, on: :collection
        end
        resources :city_ratios, only: :index do
          put '/:city_id', to: :update_city_ratio, as: :update_city_ratio, on: :collection
        end
        resources :city_dealer_percents, only: :index do
          put '/:city_id', to: :update_city_dealer_percent, as: :update_city_dealer_percent, on: :collection
        end
        resources :seasonal_factors, only: [:index, :update]
        resources :loyalties, only: [:index, :update]
        resources :packages, only: [:index, :new, :create, :update]
      end

      resources :certificates, except: :show
    end

    resources :tags, :except => [:show] do
      post :accept, :on => :member
    end

    resources :tasks, except: [:index, :show, :new] do
      get 'get_firm_catalog_children', on: :collection
      member do
        post 'load_file'
        delete 'files/:file_id/remove', as: 'remove_file', action: 'remove_file'
        delete 'images/:image_id/remove', as: 'remove_image', action: 'remove_image'
        put :update_all_events
      end
    end
    resources :task_categories do
      get 'tasks/new' => 'tasks#new', on: :member
    end
    resources :scripts, except: [:show] do
      resources :plans, only: [:edit, :update] do
        member do
          post 'add_task/:task_id', as: 'add_task', action: 'add_task', controller: 'plans'
          post 'remove_task/:task_id', as: 'remove_task', action: 'remove_task', controller: 'plans'
          post :order_tasks
        end
      end
    end

    resources :posts, only: [:index]
    resources :videos, only: [:index]
    resources :complaints, only: [:index, :show, :destroy]

    resources :community_categories do
      put :order_categories, on: :collection
      member do
        put :order_communities
        delete :remove_avatar
        get 'communities/new' => 'communities#new'
      end
    end
    resources :communities, except: [:new, :index] do
      member do
        post :add_moderator
        delete 'remove_moderator/:user_id', action: 'remove_moderator', as: 'remove_moderator'
        post :add_post_category
        delete 'remove_post_category/:post_category_id', action: 'remove_post_category', as: 'remove_post_category' 
        delete :remove_logo
        put 'update_post_category/:post_category_id', to: :update_post_category, as: :update_post_category
      end
    end

    resources :questions, only: [:show, :edit, :update, :destroy, :index] do
      member do
        post 'recommend'
        post 'unrecommend'
      end
    end
    resources :question_categories
    namespace :idea do
      resources :categories do
        member do
          get  :new_add_ideas
          post :add_ideas
          post :move_left
          post :move_right
        end
      end
      resources :ideas, except: [:new, :create]
      resources :collections
      resources :sections do
        member do
          get    :new_add_category
          post   :add_category
          post   :move_left
          post   :move_right
          delete :remove_category
          get    :get_categories
        end
      end
    end

    resources :photos

    resources :static_pages
    resources :background_properties do
      get '/:type/list', to: :index, as: :select, on: :collection
    end

    resources :cities

    resources :user_admins, only: [:index] do
      member do
        post 'make'
        delete 'remove'
      end
    end

    resources :mail_templates do
      post 'send_mails', on: :member
    end

    resources :banners, except: :show
  end

  resources :message_rooms do
    get :read, on: :member
  end

  resources :messages do
    get :append, on: :member
    get 'new/:user_id' => 'messages#new', as: :new, on: :collection
    resources :images, only: :create, controller: :attachment_images
  end

  resources :comments, only: [ :create, :show, :update, :destroy ] do
    resources :images, only: [ :create, :show, :destroy ], controller: :attachment_images
  end
  resources :complaints, only: [ :new, :create ]
  resources :favorites, only: [ :index, :create, :destroy ]

  resources :cities, only: [] do
    resources :firm_catalogs, path: 'catalogs', only: [] do
      resources :firms, only: :index
    end
  end

  resources :firms, :except => [:new, :create] do

    collection do
      get 'get_firm_catalog_children'
      get 'check_slug_present'
      get 'search'
    end

    member do
      get 'posts'
      get 'comments'
      get 'customers'
      get 'partners'
      get 'checkout'
      get 'change_text_status'
      get 'addresses'
      get 'albums'
      get 'albums/:album_id', action: 'show_album', constraints: { album_id: /[0-9]+/ }
      get 'pages/:firm_page_id', action: 'show_page', constraints: { album_id: /[0-9]+/ }, as: :firm_page
      get 'videos'
      get 'get_phone/:city_firm_id', action: 'get_phone', constraints: { city_firm_id: /[0-9]+/ }, as: :get_phone
      put 'update_user_email'
      put 'update_slug'
      post 'update_wedding_city', as: :update_wedding_city
    end

    resources :posts, except: [:new, :create]

    resources :albums, except: [:index, :show] do
      resources :photos
      post 'upload_photo', on: :member
    end

    resources :competitions, :except => :index do
      resources :albums do
        resources :photos
      end
      collection do
        get 'firm_index'
      end
    end

    resources :addresses, :except => [:index, :show]
    resource :business, :controller => 'business', :only  => :destroy
    resources :videos, except: :index
    resources :firm_services do
      post :change_rating, on: :collection
    end
    resources :city_firms do
      resources :addresses, only: [] do
        post :sort, on: :collection
      end
      post :rating, on: :collection
      put :change_city, on: :member
    end
    resources :firm_pages, except: [:index, :show, :edit] do
      resources :images, only: [ :create, :destroy ], controller: :attachment_images
      post :change_rating, on: :collection
      post :switch, on: :member
    end

    resources :spheres, only: [:create, :destroy]
  end

  resources :purse_payments, only: :index

  namespace :bonus do
    resources :services, only: [] do
      get :price, on: :member
      resources :subscriptions, only: [:new, :create]
    end

    resources :certificates, only: [] do
      post :assign, on: :collection
    end
  end

  namespace :payment do
    resources :interkassa_deposits, only: [:new, :create] do
      collection do
        get   :success
        get   :pending
        get   :fail
        post  :result
      end
    end
  end

  resources :users do
    get 'check_email_present', on: :collection
    get 'check_email', on: :collection
    put 'update_phone', on: :member
  end

  resources :clients, path: :profiles, only: [:index]
  resources :clients, path: :profile, except: [:index] do
    resources :posts, except: :index

    resources :wedding_invites, only: [], path: 'invite', as: 'invite' do
      member do
        post 'confirm'
        put  'reject'
      end
    end

    member do
      put 'update_user_email'
      put 'update_status'
      get 'search_couple'
      put 'update', as: :update
      get 'albums'
      get 'videos'
      get 'posts'
      get 'friends'
      get 'firms'
      get 'albums/:album_id', action: 'show_album', constraints: { album_id: /[0-9]+/ }
      delete 'destroy_avatar'
      post 'update_wedding_city', as: :update_wedding_city
      get 'avatar'
    end

    resources :videos, except: :index
    resources :albums, except: [:index, :show] do
      resources :photos
      post 'upload_photo', on: :member
    end
  end

  match 'background_properties/:type' => 'background_properties#index', via: :get, as: :select_background_properties

  match "/wedding" => redirect("/wedding/timetables"), :via => :get
  match "/planning" => redirect("/wedding/plans/edit"), :via => :get

  resource :wedding, :except => [:show, :update] do

    collection do
      post 'change_avatar'
      post 'change_couple'
      post 'invite_couple'
    end

    resources :timetables, only: [:index,:show, :edit, :update] do
      resources :events do
        member do
          get 'firms_search'
          put 'change_status'
          get 'ideas/:ideas_page', action: 'ideas', as: 'ideas_page'
          get 'posts/:posts_page', action: 'posts', as: 'posts_page'
          get 'video/:video_page', action: 'video', as: 'video_page'
          put 'subevents/:subevent_id/status/:status_id', action: 'subevent_status', as: 'subevent'
        end
      end
    end
  end

  resources :communities, only: [:index, :show, :update] do
    member do
      get 'categoty/:post_category_id', action: :show, constraints: { album_id: /[0-9]+/ }, as: 'post_category'
      get 'join_the_community'
      get 'leave_the_community'
      get 'members'
      get 'rules'
      get 'albums'
      get 'images'
      get 'albums/:album_id', action: 'show_album', constraints: { album_id: /[0-9]+/ }
      delete 'destroy_avatar'
      get 'posts/:post_id', action: 'show_post', constraints: { post_id: /[0-9]+/ }, as: 'show_post'
    end
    resources :albums, except: [:show, :index] do
      resources :photos
      post 'upload_photo', on: :member
    end

    resources :images, only: [:show], controller: :attachment_images
    resources :posts, except: [:show] do
     resources :images, only: [:create, :index]
     resources :images, only: [:show], controller: :attachment_images
    end

    # resources :videos

    # resources :questions,  controller: 'community_questions' do
    #   resources :answers, controller: 'community_question_answers' do
    #     member do
    #       post 'best_answer'
    #     end
    #   end
    # end
  end


  resources :questions do
    resources :answers, :only => [:create, :destroy] do
      member do
        post "best_answer"
      end
    end
  end
  #resources :firm_catalogs, :path => "/admin/firm_catalogs"

  resources :posts, only: [] do
    member do
      post :accept
      post :refuse
    end
    resources :images, only: [ :create, :show, :destroy ], controller: :attachment_images
  end

  resource :interesting, only: :show, controller: :interesting do
    get :videos
  end

  resources :videos, only: [] do
    member do
      post :accept
      post :refuse
    end
    get :all, on: :collection
  end

  get '*page_url' => 'static_pages#show', as: :static_page

end
end
