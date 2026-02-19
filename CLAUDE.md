# CLAUDE.md — NighTrip Development Guide

## Project Overview

NighTrip (https://nightrip.net/) is a night-view spot sharing web application.

**Tech Stack:** Rails 7.2 + Hotwire (Turbo/Stimulus) + Tailwind CSS / daisyUI + PostgreSQL
**Hosting:** Render (Web + DB), AWS S3 (images)
**APIs:** Google Maps JavaScript API, Google OAuth 2.0

## Development Commands

```bash
# Setup
bundle install && yarn install && bin/rails db:prepare

# Run locally
bin/dev

# Tests (SDD — write specs FIRST, then implement)
bundle exec rspec                    # All tests
bundle exec rspec spec/models/       # Model specs only
bundle exec rspec spec/requests/     # Request specs only
bundle exec rspec spec/system/       # System specs only

# Quality checks (run ALL before every PR)
bin/rubocop -a                       # Auto-fix linting
bin/rubocop -f github                # CI-style output
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
├── controllers/    # Thin RESTful controllers (delegate to models)
├── models/         # Business logic lives here
├── views/          # ERB + Turbo Frames/Streams
├── javascript/     # Stimulus controllers
├── helpers/        # View helpers
├── mailers/        # Action Mailer
└── assets/         # Stylesheets (Tailwind via cssbundling)

spec/
├── models/         # Model specs (RSpec)
├── requests/       # Request/integration specs
├── system/         # System specs (Capybara + Selenium)
└── factories/      # FactoryBot factories
```

## Key Models

- `User` — Devise authentication + Google OAuth
- `Spot` — Night-view spots with geolocation (lat/lng via Geocoder)
- `Comment` — Spot comments (Turbo Streams for real-time updates)
- `Bookmark` — User bookmarks for spots
- `Tag` / `SpotTag` — Tagging system

## SDD Workflow — ALWAYS Follow This Order

**IMPORTANT: Spec Driven Development is mandatory for all features.**

1. **Explore** — Read relevant models, controllers, and existing specs before writing anything
2. **Write failing specs first** — Model specs → Request specs → System specs
3. **Confirm specs fail** — Run `bundle exec rspec <spec-file>` and verify failure
4. **Implement** — Write minimal code to make specs pass
5. **Verify** — Run full suite: `bundle exec rspec`
6. **Lint** — `bin/rubocop -a`
7. **Security** — `bin/brakeman --no-pager`
8. **PR** — Create PR with `needs-review` label

Use the `/implement-feature` skill for guided SDD workflow.

## Branching & Workflow

### Branch Naming
- Feature: `feature/issue-{number}-{slug}`
- Bug fix: `fix/issue-{number}-{slug}`
- Maintenance: `chore/issue-{number}-{slug}`

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

- Japanese UI text, English code/comments
- Controllers thin — business logic belongs in models
- Hotwire (Turbo Frames/Streams + Stimulus) for all interactivity — no heavy JS frameworks
- daisyUI component classes for UI elements
- Follow `.rubocop.yml` (rubocop-rails-omakase)

### Detailed Rules (auto-loaded by Claude Code)
- Testing/SDD: @.claude/rules/testing.md
- Rails conventions: @.claude/rules/rails-conventions.md
- Hotwire conventions: @.claude/rules/hotwire.md
