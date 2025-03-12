class BookmarksController < ApplicationController
  def create
    spot = Spot.find(params[:spot_id])
    current_user.bookmark(spot)
    redirect_to spots_path, notice: t(".success")
  end

  def destroy
    spot = current_user.bookmarks.find(params[:id]).spot
    current_user.unbookmark(spot)
    redirect_to bookmarks_path, notice: t(".success"), status: :see_other
  end
end
