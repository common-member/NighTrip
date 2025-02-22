module ApplicationHelper
  def default_meta_tags
    {
      site: "NighTrip",
      title: "NighTrip",
      reverse: true,
      charset: "utf-8",
      description: "NighTripは、美しい夜景を投稿・共有できるアプリです。",
      keywords: "夜景, 夜景スポット, 写真撮影, 旅行, インスタ映え, ライトアップ, 絶景, イルミネーション",
      canonical: request.original_url,
      separator: "|",
      image: image_url("ogp-placeholder.png"),
      og: {
        site_name: :site,
        title: title.presence || :site,
        # description:,
        type: "website",
        url: request.original_url,
        # image:, # 動的にするために空欄
        local: "ja-JP"
      },
      twitter: {
        site: "@hisa_dev",
        card: "summary_large_image"
        # image:, # 動的にするために空欄
      }
    }
  end
end
