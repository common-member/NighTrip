# サービス名：[NighTrip（ナイトリップ）](https://nightrip.net/)
### サービスURL：https://nightrip.net/
[![NighTrip画像](app/assets/images/ogp-placeholder.png)](https://nightrip.net/)

# 目次
- [サービス概要](#サービス概要)<br>
- [サービス開発背景](#サービス開発背景)<br>
- [機能紹介](#機能紹介)<br>
- [技術構成](#技術構成)<br>
  - [使用技術](#使用技術)<br>
  - [ER図](#er図)<br>
  - [画面遷移図](#画面遷移図)<br>
  - [講師の方へ](#講師の方へ)<br>
<br>

# サービス概要
「NighTrip（ナイトリップ）」は、夜景特化型検索サービスです。<br>
具体的には、以下のような価値を提供します。<br>
- 夜景に関する投稿や投稿へのコメント<br>
- 「夜景診断」でオススメの夜景スポットを診断<br>
- 撮影した夜景をX（旧：Twitter）などのSNSで共有<br>
- 「お気に入り機能」で気になる夜景スポットをお気に入りに保存<br>
<br>

# サービス開発背景
私は友達と夜にドライブするのが好きで、その際に夜景スポットをよく訪れていました。<br>
特に印象的だった場所は神戸の掬星台で、美しい夜景を見ながら語り合う時間は格別です。<br>
しかし、その一方で車内で「今から行く夜景スポットを探す」となると、決めるのに時間がかかったり、良いスポットを見逃してしまったりするという課題を感じました。<br>
<br>
この経験から、夜景を気軽に検索・投稿し、ユーザー同士が共有し合えるサービスを作りたいと思いました。<br>
さらに、診断機能を利用してユーザーにおすすめの夜景スポットを提案したり、もっと便利で楽しい体験を届けたいと考えています。<br>
<br>
このサービスには、夜景というデジタルな情報では伝えきれないライブ体験をより気軽に訪れる機会を創出したいという私の思いが込められています。<br>
<br>

# 機能紹介
| ユーザー登録 / ログイン |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/123f2441eadd295470884a12857fa944.gif)](https://gyazo.com/123f2441eadd295470884a12857fa944) |
| <p align="left">『ユーザー名』『メールアドレス』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。<br>ユーザー登録後は自動的にログイン処理が行われ、そのまますぐにサービスを利用できます。<br>また、Googleアカウントを用いたGoogleログインにも対応しています。<br></p> |
<br>

| 新規投稿 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/7ed0b0a822a7bb07df9d75581ec9047b.gif)](https://gyazo.com/7ed0b0a822a7bb07df9d75581ec9047b) |
| <p align="left">新規投稿機能では、「スポット名」「都道府県」「位置情報」「公式サイト」「雰囲気」「タグ」「説明」「画像」の項目を入力して投稿することが可能です。<br>そのうち「スポット名」「都道府県」「位置情報」「雰囲気」「画像」は入力必須項目としており、夜景診断機能やGoogle Maps APIなどの各種機能で使用されます。<br></p> |
<br>

| コメント（非同期） |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/3788d4b8373d4bdc71c770f08157db6c.gif)](https://gyazo.com/3788d4b8373d4bdc71c770f08157db6c) |
| <p align="left">各投稿にはコメントを付けることができ、コメントは非同期通信で処理されるため、画面全体の更新は発生せず、必要な部分のみが動的に反映されます。<br>編集や削除も同様に非同期で行われ、マイページで設定したコメントの背景色が反映されるため、お好みのカラーを選択して利用できます。<br></p> |
<br>

| 夜景診断 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/f708e0122f4d3f25eb3a27053d84df97.gif)](https://gyazo.com/f708e0122f4d3f25eb3a27053d84df97)|
| <p align="left">3つの質問に回答いただいた内容に応じて、アプリがオススメの夜景スポットを提案してくれる機能です。<br>タグの入力には補完機能を実装しており、既存のタグが表示されるため、スムーズに入力できます。<br>また、タグの入力だけでなく、人気タグの候補も表示され、クリックで簡単に選択できるようになっており、ユーザーが直感的に操作しやすい設計になっています。<br></p> |
<br>

| ランキング機能 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/062c35f2a3840c0e9e66fa52c61d78e9.gif)](https://gyazo.com/062c35f2a3840c0e9e66fa52c61d78e9) |
| <p align="left">ランキング機能では、ランキングやユーザーごとのお気に入り登録の総数を集計して上位表示しています。<br>ランキングに表示されている投稿のスポット名か画像をクリックしていただくことで、その投稿の詳細にアクセスできます。<br></p> |
<br>

| マイページ |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/9895aa54bc3fa90216285318eca26082.gif)](https://gyazo.com/9895aa54bc3fa90216285318eca26082) |
| <p align="left">マイページでは「アカウント情報」「コメントの背景色の変更」「投稿したスポット」「コメントした投稿」が表示され、管理できます。<br>アカウント情報の編集ページからは、アカウント情報の編集や削除が可能です。<br>コメントの背景色は、自分が投稿に対して行ったコメントの背景を変更できる機能です。<br></p> |
<br>

# 技術構成

## 使用技術
| カテゴリ | 技術内容 |
| --- | --- |
| サーバーサイド | Ruby on Rails 7.2.2.1 ・ Ruby 3.3.6 |
| フロントエンド | Hotwire（Turbo + Stimulus）・ JavaScript |
| CSSフレームワーク | Tailwind CSS ・ daisyUI |
| Web API | Google Maps API |
| データベース | PostgreSQL |
| ストレージ | Amazon S3 |
| アプリケーションサーバー | Render |
| バージョン管理 | Git ・ GitHub |
| CI/CD | GitHub Actions |
| 仮想化 | Docker |
<br>

## ER図
[![Image from Gyazo](https://i.gyazo.com/e77865ebeafc4fac722a742ae551a4c6.png)](https://gyazo.com/e77865ebeafc4fac722a742ae551a4c6)
[こちら（dbdiagram.io）](https://dbdiagram.io/d/NighTrip-6785ce446b7fa355c3c7cc11)でもご確認いただけます。
<br>

## 画面遷移図
[こちら(Figma)](https://www.figma.com/design/wJfx2YGnGh29NnKSyHBQgr/NighTrip?node-id=0-1&t=vJGRuuSqfAuQPLD2-1)でご確認いただけます。
<br>

## 講師の方へ
本アプリは、卒業制作のNighTripを新しく作り直したものになっております。<br>
現在は、[proto-NighTrip](https://github.com/common-member/proto-NighTrip)として切り分けて保存しております。<br>
ご了承ください。<br>
なお、本件につきましては、富田講師にご相談させていただきました。<br>
富田講師、ご対応いただきありがとうございました。🙇🙇🙇<br>
<br>
