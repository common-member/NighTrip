class SpotsController < ApplicationController
  before_action :set_spot, only: %i[ edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index show ranking ]

  def index
    @q = Spot.ransack(params[:q])
    @spots = @q.result.order(created_at: :desc).page(params[:page])
    @prefectures = Prefecture.all
  end

  def show
    @spot = Spot.find(params[:id])
    @comment = Comment.new
    @comments = @spot.comments.includes(:user).order(created_at: :desc)

    meta_tags = {
      title: @spot.name,
      og: {
        title: @spot.name,
        image: @spot.image.attached? ? url_for(@spot.image) : image_url("ogp-placeholder.png")
      },
      twitter: {
        image: @spot.image.attached? ? url_for(@spot.image) : image_url("ogp-placeholder.png")
      }
    }
    set_meta_tags(meta_tags)
  end

  def new
    @spot = current_user.spots.build
  end

  def edit
  end

  def create
    @spot = current_user.spots.build(spot_params)

    respond_to do |format|
      if @spot.save
        format.html { redirect_to @spot, notice: t("spots.create.success") }
        format.json { render :show, status: :created, location: @spot }
      else
        format.html { render :new, status: :unprocessable_entity, notice: t("spots.create.failure") }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to @spot, notice: t("spots.update.success") }
        format.json { render :show, status: :ok, location: @spot }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: t("spots.update.failure") }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @spot.destroy!

    respond_to do |format|
      format.html { redirect_to spots_path, status: :see_other, notice: t("spots.destroy.success") }
      format.json { head :no_content }
    end
  end

  def bookmarks
    @bookmark_spots = current_user.bookmark_spots.includes(:user).order(created_at: :desc)
  end

  def ranking
    @top_5_bookmarked_spots = Spot.ranked_by_top_5_bookmarks
    @top_5_users_by_bookmarks = User.ranked_by_top_5_bookmarked_count_users
  end

  def autocomplete
    query = params[:q]
    spots = Spot.where("name ILIKE ?", "%#{query}%").select(:name).distinct.limit(10)
    render json: spots.map { |spot| { id: nil, name: spot.name } }
  end

  private
  def set_spot
    @spot = current_user.spots.find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(:name, :prefecture_id, :address, :url, :body, :image, :tag_names)
  end
end
