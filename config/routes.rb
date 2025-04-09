Rails.application.routes.draw do
  root to: "spots#index"

  get "spots/autocomplete", to: "spots#autocomplete", as: :autocomplete_spots
  get "tags/autocomplete", to: "tags#autocomplete", as: :autocomplete_tags

  resources :spots do
    resources :comments, only: %i[edit create update destroy]
    resource :bookmarks, only: %i[create destroy]
    collection do
      get :ranking
    end
  end

  resources :bookmarks, only: %i[index]
  resource :profile, only: %i[show update]

  get "terms", to: "terms#index"
  get "guide", to: "guides#show"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
end
