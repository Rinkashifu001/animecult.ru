Animecult::Application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'omniauth_callbacks',
                            registrations: 'registrations', sessions: 'sessions' }
  devise_scope :user do
    get 'adminka' => 'devise/sessions#new'
  end

  mount Commontator::Engine => '/commontator'

  root 'search#index'

  concern :searchable do
    collection do
      get :search
    end
  end

  resources :news
  resources :video, only: :show
  resources :genre, only: %i[index show]
  resources :category, only: %i[index show]
  resources :director, only: %i[index show]
  resources :author, only: %i[index show edit update]
  resources :studio, only: %i[index show]
  resources :translator, only: %i[index show]
  resources :anime_list, only: :index
  resources :tag, only: :show
  resources :attachments, only: :destroy
  resources :comment_tool, only: :index
  resources :by_year, only: %i[index show]
  resources :character, only: %i[new create show edit update], concerns: :searchable
  resources :song, only: %i[new create show edit update], concerns: :searchable
  resources :creator, only: %i[new create show edit update], concerns: :searchable
  resources :credit, only: [], concerns: :searchable
  resources :element, only: %i[edit update new create], concerns: :searchable
  resources :users, only: [], concerns: :searchable

  resources :user_social_networks, only: :destroy do
    collection do
      get ':provider/remove', action: :remove
    end
  end

  resources :moderate, only: :index do
    collection do
      get :revisions
      get :images
      get :objects
      post :appoint_editor
      post :appoint_moderator
      post :cancel_editor
      post :cancel_moderator
      post :do_action
      post :remove_attachment
      post :apply_attachment
      post :remove_attachment_ajax
      post :upload_attachments_ajax
    end
  end

  resources :account, only: :index do
    collection do
      post :change_nickname
      post :update_password
      post :notification_read
    end
  end

  resources :posts
  resources :translates
  resources :serial do
    collection do
      post :rate
    end

    member do
      get :translate
      get :characters
      get :creators
      get :songs
      post :toggle_hide_to_unregistered
    end

    resources :episode, only: %i[new create show edit update destroy] do
      member do
        post :create_chapter_link
        post :cancel_chapter_link
        post :create_chapter_video
        post :cancel_chapter_video
        post :toggle_hide_to_unregistered
      end
    end
  end

  resources :review do
    member do
      post :remove_image
    end
  end

  resources :image_elem, only: [] do
    member do
      post :remove_image
    end
  end

  resources :public, only: [] do
    collection do
      get :user_agreement
      get :copyright_holders
    end
  end

  resources :adblock, only: %i[index create destroy]
  resources :personal, only: :show do
    collection do
      get :ajax
    end
  end

  resources :admin, only: %i[index update] do
    collection do
      post :update_account_nickname
      post :update_seo_item
      get :account
    end
  end

  resources :test, only: :index do
    collection do
      post :ajax
      get :yookassa
    end
  end

  resources :favorite, only: :index do
    collection do
      post :toggle
    end
  end

  resources :revisions, only: :show do
    member do
      post :do_cancel
      post :do_apply
    end
  end

  resources :upload, only: [] do
    collection do
      post :upload_image
    end
  end

  resources 'not_found', only: :index

  get 'sitemap' => 'search#sitemap'
  get 'feeds', to: 'review#feed', format: 'rss'
  get '*path' => 'not_found#index'
end
