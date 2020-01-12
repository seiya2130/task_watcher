Rails.application.routes.draw do
  get 'task_list/index', to:'task_list#index'
  get 'task_list/new', to:'task_list#new'
  get 'task_list/show/:id', to:'task_list#show'
  get 'task_list/edit'
  get 'static_pages/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#top'
end
