Rails.application.routes.draw do
  #セッション
  post '/guest_login', to:'sessions#guest'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
    
  #タスクリスト・タスク
  resources :task_lists do
    resources :tasks, except: [:index, :show], shallow: true
  end
  get '/tasks/progress', to:'tasks#progress'

  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:create, :show,:update,]
    end
  end

  root to: 'static_pages#top'
  get '*path', to:'static_pages#top'
  post '*path', to:'static_pages#top'
end
