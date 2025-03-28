module ApplicationHelper
  def default_meta_tags
    {
      site: "NighTrip",
      title: "夜景スポット共有アプリ",
      reverse: true,
      separator: "|",
      charset: "utf-8",
      description: "全国の美しい夜景を共有しよう。",
      canonical: request.original_url,
      og: {
        site_name: "NighTrip",
        title: "夜景スポット共有アプリ",
        description: "全国の美しい夜景を共有しよう。",
        type: "website",
        url: request.original_url,
        image: image_url("ogp-placeholder.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "https://x.com/hisa_dev",
        image: image_url("ogp-placeholder.png")
      }
    }
  end
end
