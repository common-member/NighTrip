Rails.application.routes.draw do
  authenticated :user do
    root to: "spots#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "top#home"
  end

  resources :spots do
    resources :comments, only: %i[edit create update destroy]
    resource :bookmarks, only: %i[create destroy]
  end

  resources :bookmarks, only: %i[index]

  # 利用規約
  get "terms", to: "terms#index"

  devise_for :users
end
