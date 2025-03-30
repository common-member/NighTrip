class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
	      sign_in_and_redirect @user, event: :authentication
        flash[:notice] = 'Googleアカウントでのログインに成功しました。' if is_navigational_format?
      else
	      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: 'Googleアカウントでのログインに失敗しました。'
      end
  end

  def failure
    redirect_to root_path, alert: 'Googleアカウントでのログインに失敗しました。'
  end
end
