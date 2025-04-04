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
    collection do
      get :ranking
    end
  end

  resources :bookmarks, only: %i[index]

  # 利用規約
  get "terms", to: "terms#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
end
