class CommentsController < ApplicationController
  before_action :set_spot

  def create
    @comment = @spot.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @spot, notice: "コメントが投稿されました。"
    else
      redirect_to @spot, alert: "コメントの投稿に失敗しました。"
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
