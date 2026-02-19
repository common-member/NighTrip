# SDD開発体制 — 新規リポジトリ セットアッププロンプト

> Claude Code + GitHub Mobile で世界クラスのSDD（Spec Driven Development）を即日構築する

---

## このドキュメントについて

このファイルには、**新規リポジトリを一から構築し、完全なSDD開発体制を自動セットアップする Claude Code プロンプト**が収録されています。

「セットアッププロンプト」セクションのテキストをコピーして Claude Code に貼り付けるだけで、以下のすべてが自動構築されます：

- CLAUDE.md（開発ガイド）
- `.claude/` — スキル / エージェント / ルール / フック / 設定
- `.github/` — CI/CD ワークフロー / Issue テンプレート / PR テンプレート / Dependabot
- GitHub Mobile 対応の Claude 自動化ワークフロー

---

## 世界クラスSDD実践の核心原則

世界中のソフトウェアエンジニアリング研究・実践から蒸留された最良のプラクティス：

### 1. Outside-In TDD（ロンドン学派）
ユーザーの視点から内側に向かって開発する。受け入れテスト（E2Eスペック）→ 統合テスト（リクエストスペック）→ 単体テスト（モデルスペック）の順に書く。実装の前にユーザー価値を定義する。

### 2. Red-Green-Refactor サイクル（Kent Beck）
1. **Red**: 失敗するテストを書く（実装なし）
2. **Green**: テストを通過させる最小限のコードを書く
3. **Refactor**: テストをグリーンに保ちながらコードを改善する

絶対に Green を飛ばして Refactor してはいけない。

### 3. テストピラミッド（Mike Cohn）
```
        /E2E\           ← 少数・低速・高コスト（システムスペック）
       /統合  \          ← 中程度（リクエストスペック）
      /  単体   \        ← 多数・高速・低コスト（モデルスペック）
```
単体テストを多く、E2Eを少なく維持することで、高速かつ信頼性の高いCI/CDを実現する。

### 4. FIRST 原則（Robert C. Martin）
- **F**ast — テストは数秒以内に完了すること
- **I**solated — テスト同士は完全に独立していること
- **R**epeatable — どんな環境でも同じ結果になること
- **S**elf-validating — 合否が自動で判定されること
- **T**imely — 実装コードの直前にテストを書くこと

### 5. Given-When-Then（BDD スタイル）
```ruby
# Given: テストの前提条件
# When:  テスト対象の操作
# Then:  期待される結果
context "when user is not authenticated" do
  it "redirects to login page" do
    # Given: 未認証状態
    # When: 認証が必要なページにアクセス
    get protected_path
    # Then: ログインページにリダイレクト
    expect(response).to redirect_to(new_user_session_path)
  end
end
```

### 6. Four-Phase Test（Gerard Meszaros）
すべてのテストは4つのフェーズで構成する：
1. **Setup** — テスト対象の状態を構築（`let`/`create`）
2. **Exercise** — テスト対象を操作（`get`/`post`/メソッド呼び出し）
3. **Verify** — 結果を検証（`expect`）
4. **Teardown** — 状態をリセット（`after`/FactoryBot の自動クリーンアップ）

### 7. Living Documentation（Gojko Adzic）
スペックはコードの実行可能な仕様書である。`--format documentation` で実行すると、スペックが人間が読める仕様書として機能する。スペックのドキュメント的価値を常に意識する。

### 8. 継続的インテグレーション（CI）の原則
- すべてのプッシュで自動テスト実行
- テストは常にグリーンに保つ
- 壊れたビルドを最優先で修正する
- フィーチャーブランチは短命に保つ（2日以内にマージ）

---

## 前提条件

- **GitHub リポジトリ** が作成済みであること（空でOK）
- **Claude Code CLI** がインストール済みであること（`claude` コマンドが使えること）
- **GitHub Secrets** に `ANTHROPIC_API_KEY` が設定済みであること
- ローカルで `git clone` してリポジトリに入っていること

---

## 使い方

1. 新しいリポジトリを GitHub で作成してクローンする
2. ターミナルでリポジトリのルートに移動する
3. `claude` コマンドを起動する（または `claude "..."` で直接渡す）
4. 以下の「セットアッププロンプト」セクションをすべてコピーして貼り付ける
5. Claude が確認を求めたらプロジェクト情報を入力する

---

## セットアッププロンプト

> **↓ここから下のテキストをコピーして Claude Code に貼り付けてください↓**

---

```
新規リポジトリに世界クラスのSDD（Spec Driven Development）開発体制を構築してください。

まず以下を確認してから始めてください：
1. 現在のディレクトリが正しいリポジトリのルートか確認する（ls -la）
2. 既存のファイルをリストアップする

---

## ステップ 0: プロジェクト情報の収集

ユーザーに以下を確認してください（デフォルト値があれば提案する）：

1. **プロジェクト名** — リポジトリ名（例: my-app）
2. **プロジェクトの説明** — 1〜2行の説明（例: 夜景スポット共有アプリ）
3. **技術スタック** — 以下から選択：
   - A) Rails 7+ + Hotwire + PostgreSQL（推奨）
   - B) Next.js + TypeScript + PostgreSQL
   - C) Django + Python
   - D) その他（手動入力）
4. **UIの主言語** — 日本語 / English（デフォルト: 日本語）
5. **ホスティング** — Render / Heroku / Vercel / その他

確認後、以下のファイルをすべて作成してください。

---

## ステップ 1: CLAUDE.md の作成

`CLAUDE.md` をリポジトリルートに作成する。
選択した技術スタックに合わせて内容を調整すること。
Rails スタックの場合、以下のテンプレートを使用する：

---ファイル: CLAUDE.md---
# CLAUDE.md — [PROJECT_NAME] 開発ガイド

## プロジェクト概要

[PROJECT_DESCRIPTION]

**技術スタック:** Rails 7+ + Hotwire (Turbo/Stimulus) + Tailwind CSS / daisyUI + PostgreSQL
**ホスティング:** [HOSTING]（Web + DB）

## 開発コマンド

```bash
# セットアップ
bundle install && yarn install && bin/rails db:prepare

# ローカル起動
bin/dev

# テスト（SDD — スペックを先に書く）
bundle exec rspec                    # 全テスト
bundle exec rspec spec/models/       # モデルスペックのみ
bundle exec rspec spec/requests/     # リクエストスペックのみ
bundle exec rspec spec/system/       # システムスペックのみ

# 品質チェック（PR 前に必ず実行）
bin/rubocop -a                       # 自動修正
bin/rubocop -f github                # CI スタイル出力
bin/brakeman --no-pager              # セキュリティスキャン

# データベース
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed

# アセット
bin/rails assets:precompile RAILS_ENV=test
```

## アーキテクチャ

```
app/
├── controllers/    # 薄いRESTfulコントローラー（ビジネスロジックはモデルへ）
├── models/         # ビジネスロジックはここ
├── views/          # ERB + Turbo Frames/Streams
├── javascript/     # Stimulus コントローラー
├── helpers/        # ビューヘルパー
├── mailers/        # Action Mailer
└── assets/         # スタイルシート（Tailwind via cssbundling）

spec/
├── models/         # モデルスペック（RSpec）
├── requests/       # リクエスト/統合スペック
├── system/         # システムスペック（Capybara + Selenium）
└── factories/      # FactoryBot ファクトリー
```

## GitHub Mobile ワークフロー

Claude Code は GitHub Mobile から直接操作できます。ブラウザ不要。

### Claude を起動する 4 つの方法

#### 1. `approved` ラベル（推奨 — 入力ゼロ）
新機能の実装に最適：
1. テンプレートで Issue を作成（GitHub Mobile アプリ）
2. **Labels** → `approved` を選択
3. Claude が自動起動し、Issue を `in-progress` にラベル変更

#### 2. `claude` ユーザーへのアサイン
ラベルトリガーと同様の動作。

#### 3. Actions タブ — Run Workflow（カスタムプロンプト向け）
1. リポジトリ → **Actions** タブ
2. **Claude Code** → **Run workflow**
3. 日本語または英語でプロンプトを入力 → **Run**

#### 4. コメントメンション（既存スレッドへの指示）
- 任意の Issue/PR コメントで `@claude [指示]` と書く

### ラベルフロー

```
[あなた]  Issue 作成          → ラベル: proposal
[あなた]  approved ラベル付与  → Claude 起動
[Claude]  作業中              → ラベル: in-progress
[Claude]  PR 作成             → ラベル: needs-review
[あなた]  レビュー & マージ    →（任意: auto-merge ラベル）
```

---

## SDD ワークフロー — 必ず以下の順序で進める

**重要: すべての機能でスペック駆動開発が必須です。**

1. **Explore** — 実装前に関連モデル・コントローラー・既存スペックを読む
2. **失敗するスペックを先に書く** — モデルスペック → リクエストスペック → システムスペック
3. **スペックの失敗を確認** — `bundle exec rspec <spec-file>` で失敗を確認する
4. **実装** — スペックを通過させる最小限のコードを書く
5. **検証** — 全スペック実行: `bundle exec rspec`
6. **Lint** — `bin/rubocop -a`
7. **Security** — `bin/brakeman --no-pager`
8. **PR** — `needs-review` ラベルで PR 作成

## ブランチ命名規則

- 機能: `feature/issue-{number}-{slug}`
- バグ修正: `fix/issue-{number}-{slug}`
- メンテナンス: `chore/issue-{number}-{slug}`

## ラベル体系

| ラベル | 意味 |
|--------|------|
| `approved` | 承認済み — 実装開始 |
| `proposal` | Claude の提案 — レビュー待ち |
| `in-progress` | 実装中 |
| `needs-review` | PR レビュー待ち |
| `auto-merge` | CI 通過後に自動マージ |

## CI/CD

- **CI:** GitHub Actions — Brakeman + RuboCop + RSpec
- **CD:** main プッシュで自動デプロイ

## コーディング規約

- UIテキストは日本語、コード・コメントは英語
- コントローラーは薄く — ビジネスロジックはモデルへ
- Hotwire（Turbo Frames/Streams + Stimulus）でインタラクティビティを実現
- daisyUI コンポーネントクラスを UI 要素に使用

### 詳細ルール（Claude Code で自動ロード）
- テスト/SDD: @.claude/rules/testing.md
- Rails 規約: @.claude/rules/rails-conventions.md
- Hotwire 規約: @.claude/rules/hotwire.md
---ファイルここまで---

---

## ステップ 2: .claude/settings.json の作成

```json
{
  "permissions": {
    "allow": [
      "Bash(bundle exec rspec*)",
      "Bash(bin/rubocop*)",
      "Bash(bin/brakeman*)",
      "Bash(git add*)",
      "Bash(git commit*)",
      "Bash(git diff*)",
      "Bash(git log*)",
      "Bash(git show*)",
      "Bash(git status)",
      "Bash(git branch*)",
      "Bash(git stash*)",
      "Bash(bin/rails db:migrate)",
      "Bash(bin/rails db:rollback)",
      "Bash(bin/rails db:prepare)",
      "Bash(bin/rails db:seed)",
      "Bash(bin/rails generate*)",
      "Bash(bin/rails routes*)",
      "Bash(bin/rails assets:precompile*)",
      "Bash(bin/rails runner*)",
      "Bash(bundle install)",
      "Bash(yarn install)",
      "Bash(gh issue*)",
      "Bash(gh pr*)"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(bin/rails db:drop*)",
      "Bash(bin/rails db:reset*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-edit-lint.sh"
          }
        ]
      }
    ]
  }
}
```

---

## ステップ 3: .claude/hooks/post-edit-lint.sh の作成

```bash
#!/bin/bash
# Post-edit hook: Auto-run linter autocorrect on edited files
# Triggered after Edit/Write tool use via .claude/settings.json

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Rails: Ruby ファイルに RuboCop を自動実行
if [[ -n "$FILE" && "$FILE" == *.rb && -x ./bin/rubocop ]]; then
  echo "Running RuboCop autocorrect on $FILE..." >&2
  ./bin/rubocop --autocorrect-all "$FILE" 2>/dev/null || true
fi

exit 0
```

chmod +x でスクリプトを実行可能にすること。

---

## ステップ 4: .claude/rules/testing.md の作成

世界クラスのSDD実践を組み込んだテスト規約：

---ファイル: .claude/rules/testing.md---
# テスト規約（SDD — Spec Driven Development）

## 重要: 必ずテストを先に書く

SDD ワークフローは必須：
1. 実装コードより **先に** RSpec スペックを書く（Outside-In TDD）
2. スペックの失敗を確認: `bundle exec rspec <spec-file>`
3. スペックを通過させる最小限のコードを実装する
4. 全スペックを実行: `bundle exec rspec`

## テストピラミッドの遵守

```
     E2E（システムスペック）← 少ない・遅い・UI全体
    統合（リクエストスペック）← 中程度・HTTP層
   単体（モデルスペック）   ← 多い・速い・ビジネスロジック
```

単体テストを最大化し、E2Eを最小化することで CI を高速に保つ。

## FIRST 原則

- **Fast** — テストは数秒以内に完了すること
- **Isolated** — テスト同士は独立していること（実行順序に依存しない）
- **Repeatable** — どの環境でも同じ結果になること
- **Self-validating** — 合否が自動で判定されること
- **Timely** — 実装の直前にテストを書くこと

## スペックの構成

### モデルスペック（spec/models/）
- バリデーション、アソシエーション、スコープ、インスタンスメソッドをテスト
- エッジケースと異常系もテスト

### リクエストスペック（spec/requests/）
- HTTPレスポンス、ステータスコード、リダイレクトをテスト
- 認証（`authenticate_user!`）と認可をテスト
- AJAX アクションの Turbo Stream レスポンスをテスト

### システムスペック（spec/system/）
- Capybara でユーザー向けフローをテスト
- リアルなユーザー操作（`visit`, `fill_in`, `click_button`）を使う
- JavaScript が必要な場合のみ `:js` メタデータを使用

## テスト実行

```bash
bundle exec rspec                              # 全テスト
bundle exec rspec spec/models/                 # モデルのみ
bundle exec rspec spec/requests/               # リクエストのみ
bundle exec rspec spec/system/                 # システムのみ
bundle exec rspec spec/models/user_spec.rb     # 単一ファイル
bundle exec rspec spec/models/user_spec.rb:42  # 特定の行
```

## FactoryBot の使い方

```ruby
# 永続化オブジェクト（DB レコードが必要なテスト）
user = create(:user)
spot = create(:spot, user: user)

# インメモリのみ（速い、DB 不要な場合）
user = build(:user)

# トレイトでバリエーション
admin = create(:user, :admin)
```

## RSpec パターン

```ruby
RSpec.describe Article, type: :model do
  # テスト対象には subject を使う
  subject(:article) { build(:article) }

  # ヘルパーは let で遅延ロード
  let(:user) { create(:user) }
  let!(:published) { create(:article, :published) }  # let! で即時ロード

  # Given-When-Then スタイルで記述する
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe "#publish!" do
    context "when article is draft" do
      subject(:article) { build(:article, :draft) }

      it "changes status to published" do
        # Given: 下書き記事（subject で定義済み）
        # When: publish! を呼び出す
        article.publish!
        # Then: ステータスが published に変わる
        expect(article).to be_published
      end
    end

    context "when article is already published" do
      subject(:article) { build(:article, :published) }

      it "raises an error" do
        expect { article.publish! }.to raise_error(Article::AlreadyPublishedError)
      end
    end
  end
end
```

## 認証（Devise）

```ruby
# リクエストスペック
RSpec.describe "Articles", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }  # Devise ヘルパー

  describe "GET /articles" do
    it "returns http success" do
      get articles_path
      expect(response).to have_http_status(:success)
    end
  end
end

# システムスペック
RSpec.describe "Articles", type: :system do
  let(:user) { create(:user) }
  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
  end
end
```

## 主要なアサーション

```ruby
# HTTP ステータス
expect(response).to have_http_status(:ok)
expect(response).to have_http_status(:redirect)
expect(response).to redirect_to(articles_path)

# モデルの状態変化
expect { action }.to change(Article, :count).by(1)
expect { action }.not_to change(Article, :count)

# Turbo Stream レスポンス
expect(response.media_type).to eq Mime[:turbo_stream]

# Capybara（システムスペック）
expect(page).to have_content("記事タイトル")
expect(page).to have_css(".article-card")
```
---ファイルここまで---

---

## ステップ 5: .claude/rules/rails-conventions.md の作成

---ファイル: .claude/rules/rails-conventions.md---
# Rails 規約

## コントローラー — 薄く保つ

コントローラーは HTTP を処理し、ロジックをモデルに委譲する：

```ruby
class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize_article!, only: [:edit, :update, :destroy]

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "記事を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_article!
    redirect_to root_path unless @article.user == current_user
  end

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end
end
```

## モデル — ビジネスロジックはここ

```ruby
class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true

  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }

  enum :status, { draft: 0, published: 1, archived: 2 }

  def publish!
    raise AlreadyPublishedError if published?
    update!(status: :published, published_at: Time.current)
  end
end
```

## ルート — RESTful に保つ

```ruby
Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :articles do
    resources :comments, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
  end
  resources :profiles, only: [:show, :edit, :update]
end
```

## データベースマイグレーション

- 既存のマイグレーションを変更しない — 新しいマイグレーションを作成する
- 外部キーと検索カラムにインデックスを追加する
- `references` を使うと外部キーカラムとインデックスが自動作成される

## セキュリティ

- `before_action :authenticate_user!` でアクションを保護する
- 全コントローラーでストロングパラメーターを使う
- シークレットは Rails credentials を使う: `Rails.application.credentials.some_key`
- すべての PR 前に Brakeman を実行: `bin/brakeman --no-pager`
---ファイルここまで---

---

## ステップ 6: .claude/rules/hotwire.md の作成

---ファイル: .claude/rules/hotwire.md---
# Hotwire 規約（Turbo + Stimulus）

## Turbo Frames — 部分的なページ更新

スコープ付きページ更新に使用する：

```erb
<%# app/views/articles/_article.html.erb %>
<%= turbo_frame_tag dom_id(@article) do %>
  <div class="card">
    <h2><%= @article.title %></h2>
    <%= link_to "編集", edit_article_path(@article) %>
  </div>
<% end %>

<%# app/views/articles/edit.html.erb %>
<%= turbo_frame_tag dom_id(@article) do %>
  <%= render "form", article: @article %>
<% end %>
```

## Turbo Streams — リアルタイムの複数要素更新

```ruby
def create
  @comment = @article.comments.build(comment_params.merge(user: current_user))
  if @comment.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @article }
    end
  else
    render :new, status: :unprocessable_entity
  end
end
```

```erb
<%# app/views/comments/create.turbo_stream.erb %>
<%= turbo_stream.append "comments" do %>
  <%= render @comment %>
<% end %>
<%= turbo_stream.update "comment-form" do %>
  <%= render "form", article: @article, comment: Comment.new %>
<% end %>
```

## Stimulus コントローラー

```javascript
// app/javascript/controllers/example_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]
  static values = { message: String }

  connect() {
    console.log("Controller connected")
  }

  greet() {
    this.outputTarget.textContent = this.messageValue
  }
}
```

## ベストプラクティス

- カスタム `fetch`/AJAX より Turbo を優先する
- `turbo_frame_tag` ヘルパーを使う（生の `<turbo-frame>` HTML は避ける）
- 破壊的なアクションには `data: { turbo_confirm: "確認メッセージ" }` を使う
- システムスペックで Capybara（`:js` メタデータ）を使って Turbo インタラクションをテストする
---ファイルここまで---

---

## ステップ 7: .claude/agents/spec-writer.md の作成

---ファイル: .claude/agents/spec-writer.md---
---
name: spec-writer
description: Write RSpec specs first before any implementation. Use for SDD (Spec Driven Development) workflow when adding new features or models.
tools: Read, Grep, Glob
model: sonnet
---

You are an expert Rails/RSpec spec writer following world-class SDD practices. Your role is to write comprehensive **failing** specs BEFORE any implementation code is written.

## Your Task

Write RSpec specs for: **$ARGUMENTS**

## Process

### Step 1: Explore Existing Patterns
Before writing anything, read:
- Relevant model files in `app/models/`
- Corresponding spec files in `spec/models/`, `spec/requests/`, or `spec/system/`
- Factory files in `spec/factories/`
- Routes in `config/routes.rb` (for request/system specs)

### Step 2: Identify What to Test

**Model specs** — Write when adding/modifying models:
- Validations (presence, uniqueness, length, format)
- Associations (belongs_to, has_many, etc.)
- Scopes and class methods
- Instance methods and callbacks

**Request specs** — Write when adding controller actions:
- HTTP status codes (success, redirect, unprocessable)
- Authentication (authenticated vs. unauthenticated)
- Authorization (own resource vs. others')
- Turbo Stream responses

**System specs** — Write when adding user-facing features:
- User flow from start to finish
- Form submissions (success and validation errors)
- JavaScript interactions (`:js` metadata)
- Flash messages and UI feedback

### Step 3: Apply Outside-In TDD

Write specs in this order:
1. System spec (acceptance test — defines user value)
2. Request spec (integration test — defines HTTP interface)
3. Model spec (unit test — defines business logic)

### Step 4: Write the Specs

Follow patterns from existing spec files exactly. Use:
- `create(:factory_name)` for DB-persisted objects
- `build(:factory_name)` for in-memory objects
- `sign_in user` for Devise authentication
- Given-When-Then commenting style
- Descriptive `describe`/`context`/`it` blocks

### Step 5: Output

Provide:
1. The spec file path(s)
2. Complete spec content
3. Which examples should FAIL before implementation (list them)
4. Brief description of what each group tests

**Do NOT write any implementation code.** Your job ends with the specs.
---ファイルここまで---

---

## ステップ 8: .claude/agents/security-reviewer.md の作成

---ファイル: .claude/agents/security-reviewer.md---
---
name: security-reviewer
description: Review code for security vulnerabilities. Use before creating a PR to catch security issues early.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a Rails security expert. Your job is to review code for security vulnerabilities before it ships.

## Your Task

Review for security issues: **$ARGUMENTS**

If no argument given, review recently modified files.

## Security Checklist

### Authentication & Authorization
- [ ] All sensitive actions protected with `before_action :authenticate_user!`
- [ ] Users can only access/modify their own resources
- [ ] No IDOR vulnerabilities (direct object reference without ownership check)

### Strong Parameters (Mass Assignment)
- [ ] All controllers use `params.require(...).permit(...)` with explicit field list
- [ ] No `permit!` or overly broad permitting

### SQL Injection
- [ ] No string interpolation in `.where()`, `.order()`, `.group()` etc.
- [ ] Use ActiveRecord placeholders: `.where("name = ?", name)` or `.where(name: name)`

### XSS Prevention
- [ ] User input not rendered with `html_safe` or `raw` without sanitization
- [ ] Using `sanitize` helper for user-generated HTML
- [ ] No inline JavaScript with user data

### CSRF Protection
- [ ] `protect_from_forgery` not disabled on sensitive controllers

### Sensitive Data
- [ ] No secrets in source code (API keys, passwords, tokens)
- [ ] Using Rails credentials or environment variables
- [ ] `.env` files listed in `.gitignore`

### File Upload (if applicable)
- [ ] File type validation (not just extension)
- [ ] Files stored via Active Storage to S3 (not local filesystem)

### Brakeman Analysis
Run and report: `bin/brakeman --no-pager`

## Output Format

Categorize findings as:
- **CRITICAL** — Must fix before merge (active vulnerability)
- **WARNING** — Should fix before merge (potential vulnerability)
- **INFO** — Consider fixing (best practice not followed)

For each finding:
- File path and line number
- What the issue is
- How to fix it

If no issues found, confirm "No security issues detected" for each category.
---ファイルここまで---

---

## ステップ 9: .claude/skills/ の作成

以下の4つのスキルファイルを作成する：

### .claude/skills/implement-feature/SKILL.md

---
name: implement-feature
description: Implement a feature using SDD. Guides through explore → write failing specs → implement → verify.
disable-model-invocation: true
argument-hint: "[feature description or issue number]"
---

# Implement Feature with SDD

**Feature**: $ARGUMENTS

Follow the Spec Driven Development workflow strictly. Do NOT skip any step.

---

## Step 1: Explore (Read Before Writing)

1. Read the relevant issue if a number was provided: `gh issue view $ARGUMENTS`
2. Read related models in `app/models/`
3. Read existing specs for similar features in `spec/`
4. Check `config/routes.rb` for existing routes
5. Check `spec/factories/` for available factories

Summarize what exists and what needs to be added.

---

## Step 2: Write Failing Specs First (Outside-In)

**Before writing any implementation code**, write RSpec specs from the outside in:

### System specs first (acceptance tests)
- File: `spec/system/<feature>_spec.rb`
- Test user flow with Capybara (user perspective)

### Then request specs (integration tests)
- File: `spec/requests/<resource>_spec.rb`
- Test HTTP status, authentication, authorization

### Then model specs (unit tests)
- File: `spec/models/<model>_spec.rb`
- Test validations, associations, scopes, and methods

Run to **confirm they fail**:
```bash
bundle exec rspec <spec-file> --format documentation
```

Show failing output. If specs pass without implementation, they test the wrong thing.

---

## Step 3: Implement (Red → Green)

Write minimal code to pass the specs:

1. Generate model/migration if needed: `bin/rails generate model ...`
2. Run migrations: `bin/rails db:migrate`
3. Add model logic (validations, associations, methods)
4. Add controller actions with authentication/authorization
5. Add views using ERB + Turbo Frames/Streams
6. Add Stimulus controller if JavaScript behavior needed

Follow existing patterns — read similar code first. No more code than needed.

---

## Step 4: Verify (Green → Refactor)

```bash
bundle exec rspec <spec-file> --format documentation
bundle exec rspec
bin/rubocop -a
bin/brakeman --no-pager
```

All checks must pass before creating a PR.

---

## Step 5: Report

Summarize:
- Specs written (file paths + count)
- Implementation files changed
- Test results (pass/fail counts)
- Any RuboCop or Brakeman findings

### .claude/skills/fix-issue/SKILL.md

---
name: fix-issue
description: Fix a GitHub issue using SDD workflow. Reproduce the bug with a failing test, then fix it.
disable-model-invocation: true
argument-hint: "[issue-number]"
---

# Fix GitHub Issue #$ARGUMENTS

## Step 1: Understand the Issue
```bash
gh issue view $ARGUMENTS
```
Identify: what is broken, expected behavior, reproduction steps.

## Step 2: Find the Root Cause
Search relevant model/controller/view. Read existing specs for this area.

## Step 3: Write a Failing Regression Test
Write a spec that **reproduces the bug** — it must FAIL with current (buggy) code.

```bash
bundle exec rspec <spec-file> --format documentation
```

## Step 4: Fix the Bug
Implement the minimal fix to pass the regression test. Don't change unrelated code.

## Step 5: Verify
```bash
bundle exec rspec <spec-file> --format documentation
bundle exec rspec
bin/rubocop -a
bin/brakeman --no-pager
```

## Step 6: Report
Summarize what was changed and which regression test was added.

### .claude/skills/review-pr/SKILL.md

---
name: review-pr
description: Review the current PR for code quality, security, and best practices.
disable-model-invocation: true
argument-hint: "[pr-number or leave empty]"
---

# PR Code Review: $ARGUMENTS

## Step 1: Identify Changed Files
```bash
gh pr diff $ARGUMENTS 2>/dev/null || git diff main..HEAD --name-only
```

## Step 2: Read Changed Files
Read the full file for each change (not just diff).

## Step 3: Review Checklist

### Best Practices
- [ ] Controllers are thin (business logic in models)
- [ ] `authenticate_user!` on all sensitive actions
- [ ] Strong parameters used (explicit `permit`)
- [ ] DRY, clear naming, no dead code

### SDD Compliance
- [ ] New features have corresponding specs
- [ ] Specs cover happy path AND error cases
- [ ] System specs cover user-facing flows

### Security
- [ ] No secrets hardcoded
- [ ] No `html_safe`/`raw` on user input
- [ ] No SQL string interpolation
- [ ] Users can only access their own resources

## Step 4: Run Security Scan
```bash
bin/brakeman --no-pager 2>/dev/null || echo "Not available"
```

## Step 5: Write Review Summary

**Summary** — What the PR does and overall assessment.
**Issues Found**:
- 🔴 MUST FIX — Critical bugs or security issues
- 🟡 SHOULD FIX — Code quality or convention issues
- 🟢 CONSIDER — Minor improvements

**Verdict**: ✅ Approved / ⚠️ Needs changes

### .claude/skills/help/SKILL.md

---
name: help
description: Show all available Claude Code commands, skills, and the GitHub Mobile workflow.
disable-model-invocation: true
argument-hint: ""
---

# Claude Code — Quick Reference

## Available Slash Commands

| Command | What It Does |
|---------|-------------|
| `/implement-feature [description or issue#]` | SDD: explore → failing specs → implement → verify |
| `/fix-issue [issue-number]` | Reproduce bug with failing test → fix → verify |
| `/review-pr [pr-number]` | Code review: best practices, security, test coverage |
| `/help` | Show this reference |

## GitHub Mobile Workflow

**Label Trigger**: Create Issue → Add `approved` label → Claude starts automatically

**Comment Trigger**: Write `@claude [instruction]` in any Issue or PR comment

**Actions Tab**: Repository → Actions → Claude Code → Run workflow → Enter prompt

## SDD Quick Summary

**Specs first → Fail → Implement → Pass → Lint → Security → PR**

1. Write failing RSpec specs
2. `bundle exec rspec <spec-file>` → must fail
3. Implement minimal code
4. `bundle exec rspec` → all green
5. `bin/rubocop -a` → no offenses
6. `bin/brakeman --no-pager` → no warnings
7. Create PR with `needs-review` label

---

## ステップ 10: .github/workflows/ci.yml の作成

（Rails 用テンプレート — 必要に応じて技術スタックに合わせて調整すること）

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [ main ]

jobs:
  scan_ruby:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true
      - name: Security scan (Brakeman)
        run: bundle exec brakeman --no-pager

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true
      - name: Lint (RuboCop)
        run: bin/rubocop -f github

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3
    steps:
      - name: Install packages
        run: sudo apt-get update && sudo apt-get install --no-install-recommends -y google-chrome-stable curl libjemalloc2 libvips postgresql-client
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true
      - name: Precompile assets
        run: bin/rails assets:precompile
        env:
          RAILS_ENV: test
      - name: Run tests
        env:
          RAILS_ENV: test
          DATABASE_URL: postgres://postgres:postgres@localhost:5432
        run: |
          bin/rails db:prepare
          bundle exec rspec --format documentation
      - name: Upload screenshots from failed system tests
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: screenshots
          path: ${{ github.workspace }}/tmp/screenshots
          if-no-files-found: ignore
```

---

## ステップ 11: .github/workflows/claude-code.yml の作成

```yaml
name: Claude Code

on:
  issues:
    types: [opened, assigned, labeled]
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  pull_request_review:
    types: [submitted]
  workflow_dispatch:
    inputs:
      prompt:
        description: 'Claudeへの指示（日本語OK）'
        required: true
        type: string

permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write
  actions: read

jobs:
  claude-interactive:
    if: |
      (github.event_name == 'issues' && github.event.label.name == 'approved') ||
      (github.event_name == 'issues' && github.event.action == 'assigned') ||
      (github.event_name == 'issue_comment' && (
        contains(github.event.comment.body, '@claude') ||
        contains(github.event.comment.body, '@Claude')
      )) ||
      (github.event_name == 'pull_request_review_comment' && (
        contains(github.event.comment.body, '@claude') ||
        contains(github.event.comment.body, '@Claude')
      )) ||
      (github.event_name == 'pull_request_review' && (
        contains(github.event.review.body, '@claude') ||
        contains(github.event.review.body, '@Claude')
      ))
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Run Claude Code
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          trigger_phrase: "@claude"
          label_trigger: "approved"
          assignee_trigger: "claude"
          track_progress: true
          additional_permissions: "actions: read"
      - name: Update issue labels
        if: success() && github.event_name == 'issues' && github.event.label.name == 'approved'
        run: |
          gh issue edit ${{ github.event.issue.number }} \
            --remove-label "approved" \
            --add-label "in-progress"
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  claude-dispatch:
    if: github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Run Claude Code
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: ${{ github.event.inputs.prompt }}
          track_progress: true
          additional_permissions: "actions: read"
```

---

## ステップ 12: .github/workflows/claude-review.yml の作成

```yaml
name: Claude PR Review

on:
  pull_request:
    types: [opened, synchronize, ready_for_review, reopened]

permissions:
  contents: read
  pull-requests: write
  issues: write
  id-token: write
  actions: read

jobs:
  review:
    if: |
      github.event.pull_request.draft == false &&
      github.actor != 'dependabot[bot]'
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 1
      - name: Claude Code Review
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          use_sticky_comment: true
          track_progress: true
          include_fix_links: true
          additional_permissions: "actions: read"
          prompt: |
            REPO: ${{ github.repository }}
            PR NUMBER: ${{ github.event.pull_request.number }}

            このPRをレビューしてください。以下の観点で確認:
            - コード品質とベストプラクティス（薄いコントローラー・モデルへの委譲）
            - バグの可能性
            - セキュリティ上の問題（OWASP Top 10）
            - N+1クエリなどのパフォーマンス問題
            - テストの十分性（SDD: スペックが先に書かれているか・テストピラミッド準拠か）
            - 破壊的変更の有無

            問題を見つけたらインラインコメントで具体的に指摘してください。
            重大な問題がなければ簡潔にApproveしてください。
          claude_args: |
            --max-turns 10
```

---

## ステップ 13: .github/workflows/auto-merge-dependabot.yml の作成

```yaml
name: Auto-merge Dependabot

on:
  pull_request:
    types: [opened, synchronize]

permissions:
  contents: write
  pull-requests: write

jobs:
  auto-merge:
    if: github.actor == 'dependabot[bot]'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Fetch Dependabot metadata
        id: metadata
        uses: dependabot/fetch-metadata@v2
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}

      - name: Auto-merge patch updates
        if: steps.metadata.outputs.update-type == 'version-update:semver-patch'
        run: gh pr merge --auto --squash "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Label minor/major updates for review
        if: |
          steps.metadata.outputs.update-type == 'version-update:semver-minor' ||
          steps.metadata.outputs.update-type == 'version-update:semver-major'
        run: gh pr edit "$PR_URL" --add-label "needs-review"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## ステップ 14: .github/ISSUE_TEMPLATE/ の作成

### config.yml
```yaml
blank_issues_enabled: false
contact_links:
  - name: Claude Code で直接実行
    url: https://github.com/[OWNER]/[REPO]/actions/workflows/claude-code.yml
    about: Issue を作らずに Claude に直接指示を出す場合はこちら
```

### feature-request.yml
```yaml
name: 機能リクエスト
description: 新機能の提案
labels: ["proposal"]
body:
  - type: markdown
    attributes:
      value: |
        ## Claude に実装してもらう方法
        1. この Issue を作成する
        2. `approved` ラベルを付ける → Claude が自動で実装を開始します
  - type: textarea
    id: description
    attributes:
      label: やりたいこと
      description: 何を実現したいか、具体的に説明してください
    validations:
      required: true
  - type: dropdown
    id: priority
    attributes:
      label: 優先度
      options:
        - 高（すぐ欲しい）
        - 中（あると良い）
        - 低（余裕があれば）
    validations:
      required: true
  - type: textarea
    id: acceptance
    attributes:
      label: 受け入れ基準（任意）
      description: どうなったら完成とみなすか
```

### bug-report.yml
```yaml
name: バグ報告
description: 不具合の報告
labels: ["bug"]
body:
  - type: textarea
    id: description
    attributes:
      label: 何が起きたか
      description: 実際の動作を説明してください
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: 期待する動作
      description: どう動くべきかを説明してください
    validations:
      required: true
  - type: dropdown
    id: severity
    attributes:
      label: 深刻度
      options:
        - 致命的（サービス停止・データ損失）
        - 高（主要機能が壊れている）
        - 中（一部機能に問題）
        - 低（軽微な不具合）
    validations:
      required: true
  - type: textarea
    id: steps
    attributes:
      label: 再現手順（任意）
```

---

## ステップ 15: .github/dependabot.yml の作成

```yaml
version: 2
updates:
  - package-ecosystem: "bundler"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 10
    groups:
      patch-updates:
        update-types:
          - "minor"
          - "patch"

  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5
```

---

## ステップ 16: .github/pull_request_template.md の作成

```markdown
## Summary

<!-- What does this PR do? Link the related issue. -->

Closes #

## Changes

-

## SDD Confirmation

<!-- Verify that Spec Driven Development was followed -->

- [ ] Specs were written **before** implementation code (Outside-In TDD)
- [ ] Failing specs were confirmed before implementing (Red phase)
- [ ] All new functionality is covered by specs
- [ ] Test pyramid is respected (unit > integration > E2E)

## Test Plan

- [ ] `bundle exec rspec` passes (all tests green)
- [ ] `bin/rubocop` passes (no linting errors)
- [ ] `bin/brakeman --no-pager` passes (no security warnings)
- [ ] Manual verification performed (if applicable)

## Screenshots (if UI change)

<!-- Drag & drop screenshots here -->
```

---

## ステップ 17: GitHub ラベルの作成

以下のコマンドでラベルを作成する（gh CLI が使える場合）：

```bash
gh label create "approved" --color "0075ca" --description "承認済み — Claude が実装を開始"
gh label create "proposal" --color "cfd3d7" --description "Claude の提案 — レビュー待ち"
gh label create "in-progress" --color "e4e669" --description "実装中"
gh label create "needs-review" --color "d93f0b" --description "PRレビュー待ち"
gh label create "auto-merge" --color "0e8a16" --description "CI通過後に自動マージ"
```

---

## ステップ 18: 最終確認

以下をすべて確認してください：

1. `CLAUDE.md` が存在すること
2. `.claude/settings.json` が存在すること
3. `.claude/hooks/post-edit-lint.sh` が実行可能なこと（chmod +x）
4. `.claude/rules/testing.md` が存在すること
5. `.claude/rules/rails-conventions.md` が存在すること（Rails の場合）
6. `.claude/rules/hotwire.md` が存在すること（Rails の場合）
7. `.claude/agents/spec-writer.md` が存在すること
8. `.claude/agents/security-reviewer.md` が存在すること
9. `.claude/skills/implement-feature/SKILL.md` が存在すること
10. `.claude/skills/fix-issue/SKILL.md` が存在すること
11. `.claude/skills/review-pr/SKILL.md` が存在すること
12. `.claude/skills/help/SKILL.md` が存在すること
13. `.github/workflows/ci.yml` が存在すること
14. `.github/workflows/claude-code.yml` が存在すること
15. `.github/workflows/claude-review.yml` が存在すること
16. `.github/workflows/auto-merge-dependabot.yml` が存在すること
17. `.github/ISSUE_TEMPLATE/config.yml` が存在すること
18. `.github/ISSUE_TEMPLATE/feature-request.yml` が存在すること
19. `.github/ISSUE_TEMPLATE/bug-report.yml` が存在すること
20. `.github/dependabot.yml` が存在すること
21. `.github/pull_request_template.md` が存在すること

完了後、全ファイルの一覧を表示してセットアップ完了を報告してください。

---

> **セットアッププロンプトここまで**
```

---

## 作成されるファイル一覧

| ファイル | 役割 |
|---------|------|
| `CLAUDE.md` | Claude Code のメイン開発ガイド |
| `.claude/settings.json` | 許可/拒否コマンド、フック設定 |
| `.claude/hooks/post-edit-lint.sh` | Ruby 編集時の自動 RuboCop |
| `.claude/rules/testing.md` | SDD テスト規約（世界クラス） |
| `.claude/rules/rails-conventions.md` | Rails コーディング規約 |
| `.claude/rules/hotwire.md` | Turbo + Stimulus 規約 |
| `.claude/agents/spec-writer.md` | スペックを書く専門エージェント |
| `.claude/agents/security-reviewer.md` | セキュリティレビュー専門エージェント |
| `.claude/skills/implement-feature/SKILL.md` | `/implement-feature` スラッシュコマンド |
| `.claude/skills/fix-issue/SKILL.md` | `/fix-issue` スラッシュコマンド |
| `.claude/skills/review-pr/SKILL.md` | `/review-pr` スラッシュコマンド |
| `.claude/skills/help/SKILL.md` | `/help` スラッシュコマンド |
| `.github/workflows/ci.yml` | CI（テスト・Lint・セキュリティ） |
| `.github/workflows/claude-code.yml` | Claude 自動化ワークフロー |
| `.github/workflows/claude-review.yml` | Claude 自動 PR レビュー |
| `.github/workflows/auto-merge-dependabot.yml` | Dependabot 自動マージ |
| `.github/ISSUE_TEMPLATE/config.yml` | Issue テンプレート設定 |
| `.github/ISSUE_TEMPLATE/feature-request.yml` | 機能リクエストテンプレート |
| `.github/ISSUE_TEMPLATE/bug-report.yml` | バグ報告テンプレート |
| `.github/dependabot.yml` | 依存関係自動アップデート |
| `.github/pull_request_template.md` | PR テンプレート（SDD確認チェックリスト付き） |

---

## カスタマイズのポイント

### Rails 以外のスタックへの適応

| 項目 | Rails | Next.js | Django |
|------|-------|---------|--------|
| テストフレームワーク | RSpec | Jest/Vitest | pytest |
| Lint | RuboCop | ESLint | Ruff/Flake8 |
| セキュリティスキャン | Brakeman | npm audit | Bandit |
| CI の Ruby セットアップ | ruby/setup-ruby | actions/setup-node | actions/setup-python |
| DB マイグレーション | `bin/rails db:migrate` | `npx prisma migrate` | `python manage.py migrate` |

`.claude/settings.json` の `allow` リストと hooks スクリプトも合わせて変更すること。

### 多言語対応

- UIテキストが日本語の場合: CLAUDE.md に「UIテキストは日本語、コード・コメントは英語」を明記
- 英語のみのプロジェクト: CLAUDE.md と Issue テンプレートを英語に変更
- claude-review.yml の `prompt` も UI 言語に合わせて書き換える

### モノレポへの対応

- 各サービスのルートに個別の `CLAUDE.md` を置く
- `.claude/rules/` にサービス別の規約ファイルを追加
- CI ワークフローをサービス別に分割する

---

*このドキュメントは NighTrip (https://nightrip.net/) の実際の開発体制をベースに、世界クラスのSDD実践を統合して作成されました。*
