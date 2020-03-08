Rails.application.routes.draw do
  post '/guest_login', to:'sessions#guest'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  
  resources :users, only: [:show, :edit, :update]
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  resources :task_lists do
    resources :tasks, except: [:index, :show], shallow: true
  end
  get '/tasks/progress', to:'tasks#progress'

  get 'static_pages/top'  
  root to: 'static_pages#top'
end
