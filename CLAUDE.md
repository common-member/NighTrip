# CLAUDE.md — NighTrip Development Guide

## Project Overview

NighTrip (https://nightrip.net/) is a night-view spot sharing web application.

**Tech Stack:** Rails 7.2 + Hotwire (Turbo/Stimulus) + Tailwind CSS / daisyUI + PostgreSQL
**Hosting:** Render (Web + DB), AWS S3 (images)
**APIs:** Google Maps JavaScript API, Google OAuth 2.0

## Development Commands

```bash
# Setup
bundle install
yarn install
bin/rails db:prepare

# Run locally
bin/dev

# Tests
bundle exec rspec                    # All tests
bundle exec rspec spec/models/       # Model tests only
bundle exec rspec spec/system/       # System tests only

# Linting & Security
bin/rubocop -f github                # RuboCop
bin/brakeman --no-pager              # Security scan

# Database
bin/rails db:migrate
bin/rails db:seed
bin/rails db:rollback

# Assets
bin/rails assets:precompile RAILS_ENV=test
```

## Architecture

```
app/
├── controllers/    # Rails controllers (RESTful)
├── models/         # ActiveRecord models
├── views/          # ERB templates + Turbo Frames/Streams
├── javascript/     # Stimulus controllers
├── helpers/        # View helpers
├── mailers/        # Action Mailer
└── assets/         # Stylesheets (Tailwind via cssbundling)

config/
├── routes.rb       # Routing definitions
├── database.yml    # PostgreSQL config
└── environments/   # Per-environment settings

spec/
├── models/         # Model specs (RSpec)
├── system/         # System specs (Capybara + Selenium)
├── factories/      # FactoryBot factories
└── rails_helper.rb # RSpec configuration
```

## Key Models

- `User` — Devise authentication + Google OAuth
- `Spot` — Night-view spots with geolocation (lat/lng via Geocoder)
- `Comment` — Spot comments (Turbo Streams for real-time)
- `Bookmark` — User bookmarks for spots
- `Tag` / `SpotTag` — Tagging system

## Branching & Workflow

### Branch Naming
- Feature: `feature/issue-{number}-{slug}`
- Bug fix: `fix/issue-{number}-{slug}`
- Maintenance: `chore/issue-{number}-{slug}`

### Development Workflow (SDD - Spec Driven Development)
1. Check for Issues with `approved` label
2. Create feature branch from `main`
3. Write/update specs first, then implement
4. Run full test suite: `bundle exec rspec`
5. Run linter: `bin/rubocop -a` (auto-correct safe violations)
6. Run security scan: `bin/brakeman --no-pager`
7. Create PR with structured description
8. Add `needs-review` label to PR
9. After merge to `main`, Render auto-deploys

### Label System
| Label | Meaning |
|-------|---------|
| `approved` | User approved — start implementation |
| `proposal` | Claude's proposal — awaiting user review |
| `in-progress` | Implementation underway |
| `needs-review` | PR ready for user review |
| `auto-merge` | Auto-merge after CI passes |

## CI/CD

- **CI:** GitHub Actions (`.github/workflows/ci.yml`) — Brakeman + RuboCop + RSpec
- **CD:** Render auto-deploys on `main` push
- **Dependabot:** Weekly updates, auto-merge for patch versions

## Environment Variables

Required in production (Render):
- `DATABASE_URL` — PostgreSQL connection string
- `RAILS_MASTER_KEY` — Rails credentials decryption key
- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` — S3 image storage
- `AWS_BUCKET` / `AWS_REGION` — S3 bucket config
- `GOOGLE_MAPS_API_KEY` — Google Maps JavaScript API
- `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` — Google OAuth

## Coding Conventions

- Follow existing Rails conventions and Rubocop rules (`.rubocop.yml`)
- Use Hotwire (Turbo Frames/Streams + Stimulus) for interactivity — no heavy JS frameworks
- Use daisyUI component classes for UI elements
- Japanese UI text, English code/comments
- Always write RSpec tests for new features
- Keep controllers thin, models contain business logic
