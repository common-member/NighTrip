class CommentsController < ApplicationController
  before_action :set_spot, only: %i[edit create update destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def edit
  end

  def create
    @comment = @spot.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @spot, notice: "コメントが投稿されました。"
    else
      redirect_to @spot, alert: "コメントの投稿に失敗しました。"
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @spot, notice: "コメントが更新されました。"
    else
      render :edit, alert: "コメントの更新に失敗しました。"
    end
  end

  def destroy
    if @comment.user.id == current_user.id
      if @comment.destroy
        respond_to do |format|
          format.turbo_stream
        end
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
