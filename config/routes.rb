Rails.application.routes.draw do
  devise_for :users
  root to: "top#home"
end
