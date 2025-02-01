Rails.application.routes.draw do
  resources :spots
  devise_for :users
  root to: "top#home"
end
