class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_path, :notice => "Reset password email sent!"
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    user_params = params.require(:user).permit(:password, :password_confirmation)
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset has expired."
    elsif @user.update user_params
      redirect_to new_session_path, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
