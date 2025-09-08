# frozen_string_literal: true

Rails.application.routes.draw do
  get '/login' => 'sessions#new', as: 'login'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resources :potions do
    resources :ingredients
    resources :reviews
  end

  resources :ingredients
  resources :users

  root 'welcome#index'
end
