<div align="center">

# 🌃 NighTrip（ナイトリップ）

**夜景スポットを探して、共有して、お気に入りに。**

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-CC342D?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-7.2-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-4.0-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com/)
[![CI](https://github.com/common-member/NighTrip/actions/workflows/ci.yml/badge.svg)](https://github.com/common-member/NighTrip/actions/workflows/ci.yml)

**[🌐 アプリを使ってみる → https://nightrip.net/](https://nightrip.net/)**

[![NighTrip OGP](app/assets/images/ogp-placeholder.png)](https://nightrip.net/)

</div>

---

## 目次

- [サービス概要](#サービス概要)
- [サービス開発背景](#サービス開発背景)
- [主な機能](#主な機能)
- [技術構成](#技術構成)
  - [使用技術スタック](#使用技術スタック)
  - [システムアーキテクチャ](#システムアーキテクチャ)
  - [ER図](#er図)
  - [画面遷移図](#画面遷移図)
- [ローカル環境のセットアップ](#ローカル環境のセットアップ)
- [環境変数](#環境変数)
- [テスト](#テスト)
- [講師の方へ](#講師の方へ)

---

## サービス概要

**NighTrip（ナイトリップ）** は、日本全国の夜景スポットを発見・投稿・共有できるコミュニティサービスです。

夜景に特化した検索・投稿プラットフォームとして、以下の価値を提供します。

| 📍 発見する | 📸 共有する | ⭐ 保存する |
|:---:|:---:|:---:|
| 都道府県・タグ・雰囲気で夜景スポットを検索 | スポット情報・写真・コメントを投稿・共有 | 気になるスポットをブックマークして管理 |

> **「夜景を見たい」と思ったその瞬間に、最高のスポットへ辿り着ける体験を。**

---

## サービス開発背景

友達と夜にドライブするのが好きで、夜景スポットを訪れる機会が多くありました。特に神戸の掬星台で見た夜景は忘れられません。

しかし、「今から夜景スポットを探す」となると、スポット選びに時間がかかったり、良い場所を見逃してしまったりする課題がありました。

> *既存のマップサービスでは「夜景専用」で検索・投稿できるプラットフォームがなかった。*

この経験から、**夜景に特化した投稿・検索・診断機能を持つサービス**を開発しました。夜景体験をより多くの人と共有し、未知のスポットへの旅をサポートします。

---

## 主な機能

### ユーザー登録 / ログイン

| 機能 | 説明 |
|:---:|:---|
| [![ユーザー登録・ログイン](https://i.gyazo.com/123f2441eadd295470884a12857fa944.gif)](https://gyazo.com/123f2441eadd295470884a12857fa944) | メールアドレス＋パスワードでの登録のほか、**Googleアカウントによるソーシャルログイン**にも対応。登録後すぐにサービスを利用できます。 |

---

### スポット投稿

| 機能 | 説明 |
|:---:|:---|
| [![新規投稿](https://i.gyazo.com/7ed0b0a822a7bb07df9d75581ec9047b.gif)](https://gyazo.com/7ed0b0a822a7bb07df9d75581ec9047b) | スポット名・都道府県・住所・雰囲気・タグ・写真などを入力して投稿。住所は **Google Maps API** で自動的に緯度経度に変換され、地図上にピンが表示されます。 |

**入力項目（必須 *）:**

- スポット名 *
- 都道府県 *
- 住所（位置情報）*
- 雰囲気 *（静かに過ごせる / にぎやかで楽しい / 幻想的な雰囲気 / ロマンチックな空間 / 自然を感じる）
- 写真 *
- 公式サイトURL（任意）
- タグ（最大3つ、任意）
- 説明文（任意）

---

### コメント（リアルタイム更新）

| 機能 | 説明 |
|:---:|:---|
| [![コメント](https://i.gyazo.com/3788d4b8373d4bdc71c770f08157db6c.gif)](https://gyazo.com/3788d4b8373d4bdc71c770f08157db6c) | **Turbo Streams** による非同期通信で、ページ全体をリロードせずにコメントを投稿・編集・削除できます。マイページで設定したカラーがコメント背景に反映されます。 |

---

### 夜景診断

| 機能 | 説明 |
|:---:|:---|
| [![夜景診断](https://i.gyazo.com/f708e0122f4d3f25eb3a27053d84df97.gif)](https://gyazo.com/f708e0122f4d3f25eb3a27053d84df97) | 3つの質問に回答すると、あなたにぴったりの夜景スポットを提案。タグ入力には**オートコンプリート**と**人気タグ表示**を実装し、直感的に操作できます。 |

---

### ランキング

| 機能 | 説明 |
|:---:|:---|
| [![ランキング](https://i.gyazo.com/062c35f2a3840c0e9e66fa52c61d78e9.gif)](https://gyazo.com/062c35f2a3840c0e9e66fa52c61d78e9) | ブックマーク数でスポットをランキング表示。人気のスポットを一目で発見できます。投稿者ランキングも同時表示。 |

---

### マイページ

| 機能 | 説明 |
|:---:|:---|
| [![マイページ](https://i.gyazo.com/9895aa54bc3fa90216285318eca26082.gif)](https://gyazo.com/9895aa54bc3fa90216285318eca26082) | アカウント情報の編集・削除、コメント背景色のカスタマイズ、投稿スポット一覧、コメントした投稿一覧を管理できます。 |

---

### その他の機能

| 機能 | 詳細 |
|---|---|
| 🔍 スポット検索 | 都道府県・タグ・雰囲気でフィルタリング |
| 🗺️ マップ表示 | 各スポット詳細ページにGoogle Mapsでの位置表示 |
| 🔖 ブックマーク | 気になるスポットをワンクリックで保存・一覧表示 |
| 🔗 SNSシェア | X（旧Twitter）へのシェアリンク |
| 🏷️ タグ付け | スポットに最大3タグ（オートコンプリート対応） |
| 🎨 コメントカラー | ユーザーごとにコメント背景色をカスタマイズ |

---

## 技術構成

### 使用技術スタック

| カテゴリ | 技術 | バージョン |
|---|---|---|
| **バックエンド** | Ruby on Rails | 7.2.2.1 |
| **言語** | Ruby | 3.3.6 |
| **フロントエンド** | Hotwire（Turbo + Stimulus） | Turbo 8.0 |
| **CSSフレームワーク** | Tailwind CSS / daisyUI | 4.0 / 4.12 |
| **データベース** | PostgreSQL | 16 |
| **画像ストレージ** | Amazon S3 | — |
| **ホスティング** | Render | — |
| **認証** | Devise + Google OAuth 2.0 | — |
| **地図API** | Google Maps JavaScript API | — |
| **ジオコーディング** | Geocoder gem | — |
| **CI/CD** | GitHub Actions | — |
| **コンテナ** | Docker | — |
| **バージョン管理** | Git / GitHub | — |

**主要Gem:**

```
devise               # 認証・セッション管理
omniauth-google-oauth2  # Googleソーシャルログイン
geocoder             # 住所 → 緯度経度変換
ransack              # 高度な検索機能
kaminari             # ページネーション
aws-sdk-s3           # S3画像ストレージ
image_processing     # 画像リサイズ・変換
meta-tags            # OGP・SEOメタタグ
brakeman             # セキュリティスキャン
rubocop-rails-omakase # コードスタイル統一
rspec-rails          # テストフレームワーク
```

---

### システムアーキテクチャ

```
┌─────────────────────────────────────────────────────┐
│                  ユーザーのブラウザ                    │
│          Hotwire (Turbo Frames / Streams)            │
│          Stimulus Controllers / Tailwind CSS         │
└─────────────────┬───────────────────────────────────┘
                  │ HTTP/HTTPS
┌─────────────────▼───────────────────────────────────┐
│              Render Web Service                      │
│         Ruby on Rails 7.2 (Puma)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │Controllers│  │  Models  │  │    Views (ERB)   │  │
│  │  (thin)  │→ │(business │→ │  Turbo Frames/   │  │
│  │          │  │  logic)  │  │  Streams templates│  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
└──────┬──────────────┬────────────────┬──────────────┘
       │              │                │
┌──────▼──────┐ ┌─────▼──────┐ ┌──────▼──────┐
│  PostgreSQL  │ │  Amazon S3 │ │ Google APIs │
│  (Render DB) │ │  (画像)    │ │  Maps/OAuth │
└─────────────┘ └────────────┘ └─────────────┘
```

---

### ER図

[![ER図](https://i.gyazo.com/e77865ebeafc4fac722a742ae551a4c6.png)](https://gyazo.com/e77865ebeafc4fac722a742ae551a4c6)

[dbdiagram.io で確認する](https://dbdiagram.io/d/NighTrip-6785ce446b7fa355c3c7cc11)

**主なテーブル:**

```
users
  ├── spots (1:N)          # 夜景スポット投稿
  ├── comments (1:N)       # コメント
  └── bookmarks (1:N)      # ブックマーク

spots
  ├── comments (1:N)       # スポットへのコメント
  ├── bookmarks (1:N)      # スポットへのブックマーク
  ├── taggings (1:N)       # タグ紐付け（中間テーブル）
  │   └── tags (N:M)       # スポットタグ
  └── prefecture (N:1)     # 都道府県

prefectures              # 都道府県マスタ（地方別集計対応）
```

---

### 画面遷移図

[Figma で確認する](https://www.figma.com/design/wJfx2YGnGh29NnKSyHBQgr/NighTrip?node-id=0-1&t=vJGRuuSqfAuQPLD2-1)

---

## ローカル環境のセットアップ

### 前提条件

- Ruby 3.3.6
- PostgreSQL 16+
- Node.js 20+
- Yarn

### 手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/common-member/NighTrip.git
cd NighTrip

# 2. 依存関係のインストール
bundle install
yarn install

# 3. 環境変数の設定（後述）
cp .env.example .env
# .envを編集して必要な値を設定

# 4. データベースのセットアップ
bin/rails db:prepare

# 5. アセットのビルド
bin/rails assets:precompile RAILS_ENV=development

# 6. 開発サーバーの起動
bin/dev
```

ブラウザで `http://localhost:3000` にアクセスしてください。

---

## 環境変数

`.env` ファイルに以下の環境変数を設定してください:

```bash
# データベース
DATABASE_URL=postgresql://localhost/nightrip_development

# Rails
RAILS_MASTER_KEY=<rails credentials key>
SECRET_KEY_BASE=<generated secret>

# Google APIs
GOOGLE_MAPS_API_KEY=<Google Maps JavaScript API Key>
GOOGLE_CLIENT_ID=<Google OAuth Client ID>
GOOGLE_CLIENT_SECRET=<Google OAuth Client Secret>

# Amazon S3（画像ストレージ）
AWS_ACCESS_KEY_ID=<AWS Access Key>
AWS_SECRET_ACCESS_KEY=<AWS Secret Key>
AWS_BUCKET=<S3 Bucket Name>
AWS_REGION=<S3 Region e.g. ap-northeast-1>
```

---

## テスト

このプロジェクトは **SDD（Spec Driven Development）** を採用しています。
実装前に必ずRSpecで失敗するテストを書き、その後に実装します。

```bash
# 全テスト実行
bundle exec rspec

# モデルスペックのみ
bundle exec rspec spec/models/

# リクエストスペックのみ
bundle exec rspec spec/requests/

# システムスペックのみ
bundle exec rspec spec/system/

# コードスタイルチェック（自動修正）
bin/rubocop -a

# セキュリティスキャン
bin/brakeman --no-pager
```

**テストカバレッジ:**

| テスト種別 | 内容 |
|---|---|
| Model Spec | バリデーション・アソシエーション・スコープ・インスタンスメソッド |
| Request Spec | HTTPレスポンス・認証・Turbo Streamレスポンス |
| System Spec | Capybara + Seleniumによる E2E テスト |

---

## 講師の方へ

本アプリは、卒業制作のNighTripを新しく作り直したものになっております。
旧バージョンは [proto-NighTrip](https://github.com/common-member/proto-NighTrip) として保存しております。

本件につきましては、富田講師にご相談させていただきました。ご対応いただきありがとうございました。🙇

---

<div align="center">

**NighTrip** — あなたの夜景体験を、世界と共有しよう。

[🌐 https://nightrip.net/](https://nightrip.net/)

</div>
