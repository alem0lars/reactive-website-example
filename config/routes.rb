Reactivewebsiteexample::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  match '/sidebar_tiles'  => 'application#sidebar_tiles', as: :sidebar_tiles

  resources :dependencies,  only: %w(index)
  resources :projects,      only: %w(index show)
  resources :branches,      only: %w(index show)
  resources :builds,        only: %w(index show)
  resources :steps,         only: %w(index show)
  resources :actions,       only: %w(index show)

  root :to => 'pages#home'
  match '/home'   => 'pages#home',  as: :home
  match '/about'  => 'pages#about', as: :about
  match '/management'  => 'pages#management', as: :management
end
