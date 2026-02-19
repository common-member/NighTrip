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

## GitHub Mobile ワークフロー

Claude Code は GitHub Mobile から完全に操作できます。ローカル環境・PCは不要。

### 重要: 絵文字リアクションはトリガーとして使用不可

GitHub Actions は絵文字リアクション（👍 🚀 など）をワークフロートリガーとして認識しません。
GitHubの仕様上、リアクションイベントはワークフローを起動しないため、以下の方法を使用してください。

### トリガー方法（モバイル最適順）

#### 方法1: ラベルで起動 — 最推奨（タイピング不要）

Issueに `approved` ラベルを付けるだけで Claude が自動起動します。

**GitHub Mobile での操作:**
1. Issueを開く
2. 右上メニュー（...）→ "Labels" をタップ
3. `approved` を選択 → Claude が即座に作業開始

#### 方法2: Actions タブから手動実行（workflow_dispatch）

GitHub Mobile の Actions タブから Claude に直接指示を送れます。
※ ワークフローへの `workflow_dispatch` 追加が必要（後述の「推奨ワークフロー設定」参照）

**GitHub Mobile での操作:**
1. リポジトリの "Actions" タブを開く
2. 左メニューで "Claude Code" を選択
3. "Run workflow" ボタンをタップ
4. 指示内容（日本語OK）を入力 → "Run workflow" で実行

#### 方法3: コメントで起動（iOS自動大文字補正に注意）

コメントに `@claude [指示]` と書くとトリガーされます。

⚠️ **iOS の自動大文字補正**: `@claude` が `@Claude` に変換されると動作しません。
対策: バックスペースで補正を元に戻してから送信。または `/claude` （スラッシュ始まりは補正されない）でも起動可能。

### ラベルフロー

```
[あなた] Issue を作成  → "proposal" ラベル自動付与
[あなた] "approved" ラベルを追加
[Claude] 作業開始      → "in-progress" に変更
[Claude] PR を作成     → "needs-review" に変更
[あなた] PR をレビュー → マージ（または "auto-merge" ラベルで自動）
```

### スラッシュコマンド（コメントに記入）

| コマンド | 動作 |
|----------|------|
| `/implement-feature` | SDD: 探索 → スペック → 実装 → 検証 |
| `/fix-issue [番号]` | 失敗テストを書いてからバグ修正 |
| `/review-pr [番号]` | コードレビュー（Rails規約・セキュリティ・テスト） |
| `/help` | コマンド一覧を表示 |

### モバイル活用例

```
# Issue を承認して実装開始（タイピング不要）
→ "approved" ラベルを付けるだけ

# Actions タブから直接指示
→ Run workflow > "スポット検索にタグフィルターを追加して"

# PRのコードレビューを依頼
→ コメント: /review-pr

# 特定の問題を修正依頼
→ コメント: @claude RuboCop の指摘を全部直して
```

### 推奨ワークフロー設定（手動更新が必要）

`.github/workflows/claude-code.yml` に以下を追加すると、
**Actions タブからタイピングなしで Claude を起動**できるようになります:

```yaml
on:
  issues:
    types: [labeled]
  issue_comment:
    types: [created]
  workflow_dispatch:           # Actions タブから手動実行
    inputs:
      prompt:
        description: 'Claudeへの指示（日本語OK）'
        required: true
        type: string
      issue_number:
        description: '関連するIssue番号（任意）'
        required: false
        type: string
```

また、iOS自動大文字補正バグの修正として、ワークフローの `if:` 条件を以下に変更:

```yaml
if: |
  (github.event_name == 'issues' && github.event.label.name == 'approved') ||
  (github.event_name == 'issue_comment' && (
    contains(github.event.comment.body, '@claude') ||
    contains(github.event.comment.body, '@Claude')
  )) ||
  github.event_name == 'workflow_dispatch'
```

---

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
