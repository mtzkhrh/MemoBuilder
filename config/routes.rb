Rails.application.routes.draw do
  root 'home#top'
  get '/about' => 'home#about'

  devise_for :users,controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    passwords:     'users/passwords'
  }

  resources :users, only:[:index, :show, :edit, :update, :destroy] do
    resources :memos, shallow: true
    resource :relationships, only: [:create, :destroy], shallow: true
    resources :tags, only: [:index,:show]
    resources :houses, only: [:index, :show, :create, :edit, :update, :destroy], shallow: true
    resources :rooms, only:[:show, :create, :edit, :update, :destroy], shallow: true, shallow: true
    resources :stocks, only: [:index, :create, :destroy], shallow: true
  end
  resources :memos, only: [] do
    resources :comments, only: [:create, :destroy], shallow: true
    resources :likes, only: [:create, :destroy], shallow: true
  end
  get '/tags/all', to: 'tags#all'
  get '/memos/all', to: 'memos#all'

  devise_for :admin, skip: :all
  devise_scope :admin do
    get '/admin/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    post '/admin/sign_in', to: 'admins/sessions#create', as: :admin_session
    delete '/admin/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end
  namespace :admins do
    resources :users, only: [:index,:show,:destroy,:update]
    resources :memos, only: [:index,:show,:destroy]
  end
end
