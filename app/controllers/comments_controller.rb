class CommentsController < ApplicationController
  before_action :set_spot, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @spot.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @spot, notice: "コメントが投稿されました。"
    else
      redirect_to @spot, alert: "コメントの投稿に失敗しました。"
    end
  end

  def destroy
    spot = Spot.find(params[:spot_id])
    comment = spot.comments.find(params[:id])
    if comment.user.id == current_user.id
      if comment.destroy
        redirect_to spot, notice: "コメントが削除されました。"
      else
        redirect_to spot, alert: "コメントの削除に失敗しました。"
      end
    else
      redirect_to spot, alert: "他のユーザーのコメントは削除できません。"
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_comment
    @comment = @spot.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(spot_id: params[:spot_id])
  end
end
