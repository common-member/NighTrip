---
paths:
  - "spec/**/*"
  - "app/models/**/*"
  - "app/controllers/**/*"
  - "app/views/**/*"
  - "app/javascript/**/*"
---

# Testing Conventions (SDD — Spec Driven Development)

## IMPORTANT: Always Write Tests First

The SDD workflow is mandatory:
1. Write failing RSpec specs BEFORE any implementation code
2. Run specs to confirm failure: `bundle exec rspec <spec-file>`
3. Implement minimal code to pass specs
4. Run full suite: `bundle exec rspec`

Never skip the "write failing tests first" step.

## Spec Organization

### Model Specs (`spec/models/`)
- Test validations, associations, scopes, and instance methods
- Test edge cases and error conditions
- Reference existing files: `spec/models/spot_spec.rb`, `spec/models/user_spec.rb`

### Request Specs (`spec/requests/`)
- Test HTTP responses, status codes, redirects
- Test authentication (`authenticate_user!`) and authorization
- Test Turbo Stream responses for AJAX actions
- Reference existing: `spec/requests/spots_spec.rb`

### System Specs (`spec/system/`)
- Test user-facing flows with Capybara
- Use realistic user interactions (`visit`, `fill_in`, `click_button`)
- Test with JavaScript (`:js` metadata) only when needed
- Reference existing system specs for Capybara patterns

## Running Tests

```bash
bundle exec rspec                              # All tests
bundle exec rspec spec/models/                 # Models only
bundle exec rspec spec/requests/               # Requests only
bundle exec rspec spec/system/                 # System tests only
bundle exec rspec spec/models/user_spec.rb     # Single file
bundle exec rspec spec/models/user_spec.rb:42  # Specific line
```

## FactoryBot Usage

```ruby
# Persisted object (use for tests requiring DB records)
user = create(:user)
spot = create(:spot, user: user)

# In-memory only (faster, use when DB not needed)
user = build(:user)

# Traits for variations
admin = create(:user, :admin)
```

Available factories: `spec/factories/` — check before creating new ones.

## RSpec Patterns

```ruby
RSpec.describe Spot, type: :model do
  # Use subject for the object under test
  subject(:spot) { build(:spot) }

  # Use let for lazy-loaded helpers
  let(:user) { create(:user) }
  let!(:spot_with_user) { create(:spot, user: user) }  # let! for eager loading

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe "#some_method" do
    context "when condition is true" do
      it "returns expected result" do
        expect(spot.some_method).to eq(expected_value)
      end
    end

    context "when condition is false" do
      it "returns nil" do
        expect(spot.some_method).to be_nil
      end
    end
  end
end
```

## Authentication in Specs

```ruby
# Request specs — use Devise test helpers
RSpec.describe "Spots", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }  # Devise helper

  describe "GET /spots" do
    it "returns http success" do
      get spots_path
      expect(response).to have_http_status(:success)
    end
  end
end

# System specs
RSpec.describe "Spots", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user  # Devise helper
  end
end
```

## Key Assertions

```ruby
# HTTP status
expect(response).to have_http_status(:ok)           # 200
expect(response).to have_http_status(:created)      # 201
expect(response).to have_http_status(:redirect)     # 3xx
expect(response).to redirect_to(spots_path)

# Model state
expect { action }.to change(Spot, :count).by(1)
expect { action }.not_to change(Spot, :count)

# Turbo Stream responses
expect(response.media_type).to eq Mime[:turbo_stream]

# Capybara (system specs)
expect(page).to have_content("スポット名")
expect(page).to have_css(".spot-card")
expect(page).not_to have_selector("form")
```
