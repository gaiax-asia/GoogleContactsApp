class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    sign_in user
    redirect_to root_path
  end
end
