class AccountActivationsController < ApplicationController
  before_action :load_user_by_email, :valid_activation, only: :edit

  def edit
    if @user.activate
      log_in @user
      flash[:success] = t "flashes.success.account_activated"
      redirect_to @user
    else
      flash[:danger] = t "flashes.danger.invalid_activation"
      redirect_to root_path
    end
  end

  private
  def load_user_by_email
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t "flashes.danger.user_not_found"
    redirect_to root_path
  end

  def valid_activation
    is_valid =
      !@user.activated? && @user.authenticated?(:activation, params[:id])
    return if is_valid

    flash[:danger] = t "flashes.danger.invalid_activation"
    redirect_to root_path
  end
end
