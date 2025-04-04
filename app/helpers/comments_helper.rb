module CommentsHelper
  def comment_class(chat_color)
    case chat_color.presence || "デフォルト"
    when "デフォルト" then "bg-neutral text-base-content"
    when "エナジー"   then "bg-primary text-primary-content"
    when "カーム"     then "bg-secondary text-secondary-content"
    when "ポップ"     then "bg-accent text-accent-content"
    when "フレッシュ" then "bg-success text-success-content"
    when "インフォ"   then "bg-info text-info-content"
    when "サニー"     then "bg-warning text-warning-content"
    when "アラート"   then "bg-error text-error-content"
    else
      "bg-neutral text-base-content"
    end
  end
end
