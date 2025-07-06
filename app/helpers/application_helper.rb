module ApplicationHelper
  def default_meta_tags
    {
      site: "NighTrip",
      title: "",
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

  # == Buttons ==
  def back_button(label = t("helpers.label.back"))
    link_to label, :back, class: "btn btn-base w-full hover:bg-gray-600", data: { action: "click->loading#show" }
  end

  def spots_index_button(label = t("helpers.label.spots_index"))
    link_to label, spots_path, class: "btn btn-primary w-full hover:bg-gray-600", data: { action: "click->loading#show" }
  end

  def nav_link_to(name, path, icon:, alt:, style_color: "btn btn-ghost")
    active_class = current_page?(path) ? "btn-active" : ""
    link_classes = [ style_color, active_class ].join(" ").strip

    link_to path, class: link_classes, data: { action: "click->loading#show" } do
      image_tag(icon, alt: alt, class: "inline w-5 h-5 mr-1 align-text-bottom") + name
    end
  end
end
