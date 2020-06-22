Rails.application.routes.draw do
  root 'home#top'
  get '/about' => 'home#about'

  # 会員用URL
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
  }

  get '/tags/all', to: 'tags#all'
  get '/memos/all', to: 'memos#all'

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    get :relationships, on: :member
    get :stocks, on: :member
    resources :memos, shallow: true
    resource :relationships, only: [:create, :destroy], shallow: true
    resources :tags, only: [:index, :show]
    resources :houses, only: [:index, :show, :create, :edit, :update, :destroy], shallow: true
    resources :rooms, only: [:show, :create, :edit, :update, :destroy], shallow: true
  end

  # URLでmemo_idを渡すためにmemosのルートなしでネスト
  resources :memos, only: [] do
    resources :comments, only: [:create, :destroy], shallow: true
    resource :likes, only: [:create, :destroy], shallow: true
    resource :stocks, only: [:create, :destroy]
  end

  # 管理者用URL
  devise_for :admin, skip: :all
  devise_scope :admin do
    get '/admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    post '/admins/sign_in', to: 'admins/sessions#create', as: :admin_session
    delete '/admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  namespace :admins do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :memos, only: [:index, :show, :edit, :update, :destroy]
  end

  get '/admins', to: 'admins/home#top', as: :admin
end
