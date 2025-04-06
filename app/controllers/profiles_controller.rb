class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @spots = current_user.spots
    @comments = current_user.comments.includes(:spot)
  end

  def update
    if current_user.update(chat_color_params)
      redirect_to profile_path, notice: '背景色を変更しました'
    else
      redirect_to profile_path, alert: '更新に失敗しました'
    end
  end

  private

  def chat_color_params
    params.require(:user).permit(:chat_color)
  end
end
