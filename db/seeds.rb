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
