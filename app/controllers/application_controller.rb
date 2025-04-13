class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :store_user_location!, if: :storable_location?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :chat_color ])
  end

  def after_sign_in_path_for(resource)
    stored_location = stored_location_for(resource)

    # オートコンプリートなどAPI的なURLにリダイレクトしないように防止
    if stored_location.present? && stored_location.start_with?("/spots/autocomplete")
      root_path # または spots_path など、正常な画面ページに飛ぶように
    else
      stored_location || root_path
    end
  end

  private

  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr? &&
      !request.path.start_with?("/spots/autocomplete")
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
