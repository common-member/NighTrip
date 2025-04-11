class DiagnosesController < ApplicationController
  def new
    @spot = Spot.new
    @region_options = Prefecture.region_options
    @popular_tags = Tag.joins(:taggings).group(:id).order("COUNT(taggings.id) DESC").limit(10)
    @popular_tags = Tag.joins(:taggings).group(:id).order("COUNT(taggings.id) DESC").limit(10)
  end

  def result
      if params[:region].blank? || params[:atmosphere].blank? || params[:tag].blank?
      redirect_to diagnosis_path, alert: "診断条件が足りませんでした。もう一度入力してください。"
      return
      end

    region     = params[:region]
    atmosphere = params[:atmosphere]
    tag_name   = params[:tag]

    prefecture_ids = Prefecture.where(region: region).pluck(:id)

    @spots = Spot.where(prefecture_id: prefecture_ids)
                 .where(atmosphere: atmosphere)

    if tag_name.present?
      @spots = @spots.joins(:tags).where(tags: { name: tag_name })
    end

    @spots = @spots
      .left_joins(:bookmarks)
      .group("spots.id")
      .select("spots.*, COUNT(bookmarks.id) AS bookmarks_count")
      .order("bookmarks_count DESC")
      .includes(:user, :prefecture)
      .limit(3)
  end
end
