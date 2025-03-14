class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.includes(:spot).order(created_at: :desc)
  end

  def create
    spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.new(spot_id: spot.id)

    respond_to do |format|
      if bookmark.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("spot_#{spot.id}_bookmark", partial: 'spots/bookmark', locals: { spot: spot })
        end
      else
        format.html { redirect_to spot, alert: t('bookmarks.create.failure') }
      end
    end
  end

  def destroy
    spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.find_by(spot_id: params[:spot_id])

    respond_to do |format|
      if bookmark.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("spot_#{spot.id}_bookmark", partial: 'spots/bookmark', locals: { spot: spot })
        end
      else
        format.html { redirect_to spot, alert: t('bookmarks.destroy.failure') }
      end
    end
  end
end
