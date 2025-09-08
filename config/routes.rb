Rails.application.routes.draw do
  resources :potions do
    resources :ingredients
    resources :reviews
  end

  resources :ingredients
  resources :users

  root 'application#index'
end
