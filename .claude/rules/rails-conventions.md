---
paths:
  - "app/controllers/**/*"
  - "app/models/**/*"
  - "app/helpers/**/*"
  - "config/routes.rb"
  - "db/migrate/**/*"
---

# Rails Conventions

## Controllers — Keep Thin

Controllers handle HTTP, delegate logic to models:

```ruby
class SpotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_spot, only: [:show, :edit, :update, :destroy]
  before_action :authorize_spot!, only: [:edit, :update, :destroy]

  def create
    @spot = current_user.spots.build(spot_params)
    if @spot.save
      redirect_to @spot, notice: "スポットを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def authorize_spot!
    redirect_to root_path unless @spot.user == current_user
  end

  def spot_params
    params.require(:spot).permit(:name, :address, :description, :prefecture_id)
  end
end
```

Key rules:
- Use `before_action` for authentication/authorization
- Use strong parameters (`permit`) always
- `respond_to` block for Turbo Stream + HTML responses
- Never put business logic in controllers — use models

## Models — Business Logic Here

```ruby
class Spot < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :spot_tags, dependent: :destroy
  has_many :tags, through: :spot_tags

  validates :name, presence: true, length: { maximum: 50 }
  validates :address, presence: true
  validates :prefecture_id, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  scope :by_prefecture, ->(id) { where(prefecture_id: id) }
  scope :recent, -> { order(created_at: :desc) }

  def display_name
    "#{prefecture.name} / #{name}"
  end
end
```

Key rules:
- Validations at model level
- Use `scope` for reusable queries
- Use `after_validation`/`before_save` callbacks, not controller logic
- Geocoder handles lat/lng — trigger via `after_validation :geocode`

## Routes — RESTful

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "tops#index"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :spots do
    resources :comments, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
  end

  resources :profiles, only: [:show, :edit, :update]
end
```

Key rules:
- Check existing routes before adding new ones: `bin/rails routes | grep pattern`
- Use nested resources for clearly owned sub-resources
- Prefer `only:` to limit to needed actions

## Database Migrations

```bash
# Generate migration
bin/rails generate migration AddPrefectureToSpots prefecture:references

# Apply
bin/rails db:migrate

# Rollback last
bin/rails db:rollback
```

Key rules:
- Never modify existing migrations — create new ones
- Add indexes for foreign keys and frequently searched columns
- Use `references` for foreign key columns (creates index automatically)

```ruby
class AddIndexToSpotsAddress < ActiveRecord::Migration[7.2]
  def change
    add_index :spots, :address
    add_index :spots, [:prefecture_id, :created_at]
  end
end
```

## Security

- Protect actions: `before_action :authenticate_user!`
- Strong parameters in every controller
- Use Rails credentials for secrets: `Rails.application.credentials.some_key`
- Never commit `.env` or secrets — use environment variables
- Run Brakeman before every PR: `bin/brakeman --no-pager`
