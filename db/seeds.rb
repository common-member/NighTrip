# マスターテーブル設定
## prefecturesテーブル
prefectures = [
  { name: "北海道", region: 0 },  # 北海道地方
  { name: "青森県", region: 1 },  # 東北地方
  { name: "岩手県", region: 1 },
  { name: "宮城県", region: 1 },
  { name: "秋田県", region: 1 },
  { name: "山形県", region: 1 },
  { name: "福島県", region: 1 },
  { name: "茨城県", region: 2 },  # 関東地方
  { name: "栃木県", region: 2 },
  { name: "群馬県", region: 2 },
  { name: "埼玉県", region: 2 },
  { name: "千葉県", region: 2 },
  { name: "東京都", region: 2 },
  { name: "神奈川県", region: 2 },
  { name: "新潟県", region: 3 },  # 中部地方
  { name: "富山県", region: 3 },
  { name: "石川県", region: 3 },
  { name: "福井県", region: 3 },
  { name: "山梨県", region: 4 },  # 甲信越地方
  { name: "長野県", region: 4 },
  { name: "岐阜県", region: 5 },  # 東海地方
  { name: "静岡県", region: 5 },
  { name: "愛知県", region: 5 },
  { name: "三重県", region: 5 },
  { name: "滋賀県", region: 6 },  # 近畿地方
  { name: "京都府", region: 6 },
  { name: "大阪府", region: 6 },
  { name: "兵庫県", region: 6 },
  { name: "奈良県", region: 6 },
  { name: "和歌山県", region: 6 },
  { name: "鳥取県", region: 7 },  # 中国地方
  { name: "島根県", region: 7 },
  { name: "岡山県", region: 7 },
  { name: "広島県", region: 7 },
  { name: "山口県", region: 7 },
  { name: "徳島県", region: 8 },  # 四国地方
  { name: "香川県", region: 8 },
  { name: "愛媛県", region: 8 },
  { name: "高知県", region: 8 },
  { name: "福岡県", region: 9 },  # 九州地方
  { name: "佐賀県", region: 9 },
  { name: "長崎県", region: 9 },
  { name: "熊本県", region: 9 },
  { name: "大分県", region: 9 },
  { name: "宮崎県", region: 9 },
  { name: "鹿児島県", region: 9 },
  { name: "沖縄県", region: 9 }
]

prefectures.each do |prefecture|
  Prefecture.find_or_create_by(name: prefecture[:name]) do |p|
    p.region = prefecture[:region]
  end
end

# 初期ユーザー
user = User.find_or_create_by!(email: "master@example.com") do |u|
  u.password = "hogehoge"
  u.password_confirmation = "hogehoge"
  u.name = "master"
end

# Spot投稿に関するデータ
spots = [
  {
    name: "函館山展望台",
    prefecture_id: Prefecture.find_by(name: "北海道").id,
    address: "函館市函館山",
    url: "https://www.hakobura.jp/charm-tags/1",
    body: "函館の夜景が一望できる展望台。ロープウェイや車でアクセス可能。",
    user_id: user.id,
    image: "hakodateyama.jpg"
  },
  {
    name: "横浜ランドマークタワー スカイガーデン",
    prefecture_id: Prefecture.find_by(name: "神奈川県").id,
    address: "横浜市西区みなとみらい2-2-1",
    url: "https://www.yokohama-landmark.jp/skygarden/",
    body: "横浜のシンボル的存在である展望台。みなとみらいの夜景が美しい。",
    user_id: user.id,
    image: "skygarden.jpg"
  },
  {
    name: "東京タワー",
    prefecture_id: Prefecture.find_by(name: "東京都").id,
    address: "港区芝公園4丁目2-8",
    url: "https://www.tokyotower.co.jp/",
    body: "東京を代表するランドマーク。夜景スポットとしても有名。",
    user_id: user.id,
    image: "tokyotower.jpg"
  },
  {
    name: "東京スカイツリー",
    prefecture_id: Prefecture.find_by(name: "東京都").id,
    address: "墨田区押上一丁目1番2号",
    url: "https://www.tokyo-skytree.jp/",
    body: "世界一高い自立式電波塔。展望台からの眺めが魅力。",
    user_id: user.id,
    image: "skytree.jpg"
  },
  {
    name: "梅田スカイビル 空中庭園展望台",
    prefecture_id: Prefecture.find_by(name: "大阪府").id,
    address: "大阪市北区大淀中1-1-88",
    url: "https://www.skybldg.co.jp/",
    body: "大阪のパノラマ夜景を楽しめる展望台。空中庭園が特徴的。",
    user_id: user.id,
    image: "skybuilding.jpg"
  },
  {
    name: "城山公園",
    prefecture_id: Prefecture.find_by(name: "鹿児島県").id,
    address: "鹿児島市城山町",
    url: "",
    body: "鹿児島市内を一望できる景観スポット。夜景も美しい。",
    user_id: user.id,
    image: "shiroyama.jpg"
  },
  {
    name: "ビーナスブリッジ",
    prefecture_id: Prefecture.find_by(name: "兵庫県").id,
    address: "神戸市中央区諏訪山公園展望台",
    url: "",
    body: "神戸の夜景が一望できるスポット。特に恋人たちに人気。",
    user_id: user.id,
    image: "venusbridge.jpg"
  },
  {
    name: "摩耶山掬星台",
    prefecture_id: Prefecture.find_by(name: "兵庫県").id,
    address: "神戸市灘区摩耶山",
    url: "https://www.kobe-park.or.jp/maya/",
    body: "神戸の夜景を楽しめる展望台。天気が良ければ遠くの山々も一望できる。",
    user_id: user.id,
    image: "kikuseidai.jpg"
  },
  {
    name: "福岡タワー",
    prefecture_id: Prefecture.find_by(name: "福岡県").id,
    address: "福岡市早良区百道浜2丁目3-26",
    url: "https://www.fukuokatower.co.jp/",
    body: "福岡市のシンボル的なタワーで、展望台からは博多湾や市内の夜景を楽しめる。",
    user_id: user.id,
    image: "fukuokatower.jpg"
  },
  {
    name: "高松シンボルタワー",
    prefecture_id: Prefecture.find_by(name: "香川県").id,
    address: "高松市サンポート2-1",
    url: "https://www.symboltower.com/",
    body: "高松市のシンボルタワーで、展望台からは瀬戸内海と高松市内の夜景を楽しめる。",
    user_id: user.id,
    image: "symboltower.jpg"
  }
]

spots.each do |spot|
  spot_record = Spot.create(
    name: spot[:name],
    prefecture_id: spot[:prefecture_id],
    address: spot[:address],
    url: spot[:url],
    body: spot[:body],
    user_id: spot[:user_id]
  )

  image_path = Rails.root.join("db", "seeds", "images", "spots", spot[:image])

  if File.exist?(image_path)
    spot_record.image.attach(io: File.open(image_path), filename: spot[:image])
  else
    puts "画像ファイルが見つかりません: #{image_path}"
  end
end
