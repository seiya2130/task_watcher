Rails.application.routes.draw do
  #タスクリスト・タスク
  resources :task_lists do
    resources :tasks, except: [:index, :show], shallow: true
  end
  get '/tasks/progress', to:'tasks#progress'

  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:create, :show,:update,]
      resources :sessions, only: [:create,:destroy]
    end
  end

  root to: 'static_pages#top'
  get '*path', to:'static_pages#top'
  post '*path', to:'static_pages#top'
end
