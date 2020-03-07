Rails.application.routes.draw do
  post '/guest_login', to:'sessions#guest'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  patch '/users/:id',  to: 'users#update'
  get  '/users/:id/edit',  to: 'users#edit'
  get  '/users/:id',  to: 'users#show'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get 'tasks/progress', to:'tasks#progress'
  post 'tasks/:id/destroy', to:'tasks#destroy'
  get 'tasks/:id', to:'tasks#edit'
  patch 'tasks/:id', to:'tasks#update'  

  resources :task_lists 

  get 'static_pages/top'  
  root to: 'static_pages#top'
end
