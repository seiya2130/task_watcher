Rails.application.routes.draw do

  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:create, :show,:update,]
      resources :sessions, only: [:create,:destroy]
      resources :task_lists do
        resources :tasks, except: [:index, :show], shallow: true
      end
    end
  end

  get '/api/v1/tasks/progress', to: 'api/v1/tasks#progress'

  root to: 'static_pages#top'
  get '*path', to:'static_pages#top'
  post '*path', to:'static_pages#top'
end
