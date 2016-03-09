class CallbacksController < ApplicationController
  def twitter
    omniauth_data = request.env['omniauth.auth']
    user = User.find_twitter_user(omniauth_data)
    user ||= User.create_from_twitter(omniauth_data)
    sign_in(user)
    redirect_to root_path, notice: "Signed In!"
  end
end
