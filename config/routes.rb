Rails.application.routes.draw do
  post '/guest_login', to:'sessions#guest'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  patch '/users/:id',  to: 'users#update'
  get  '/users/:id/edit',  to: 'users#edit'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  resources :users, only: [:show, :edit, :update]
  get '/tasks/progress', to:'tasks#progress'
  
  resources :task_lists do
    resources :tasks, except: [:index, :show], shallow: true
  end

  get 'static_pages/top'  
  root to: 'static_pages#top'
end
