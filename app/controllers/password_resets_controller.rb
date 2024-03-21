class PasswordResetsController < ApplicationController
  layout "new-layout"
  before_action :load_user_by_email, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_mail
      flash[:info] = t "flashes.info.reset_password"
      redirect_to root_path
    else
      flash.now[:danger] = t "flashes.danger.reset_password"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("flashes.danger.password_empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "flashes.success.update_password"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def load_user_by_email
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "flashes.danger.user_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "flashes.danger.invalid_activation"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flashes.danger.password_reset_expired"
    redirect_to new_password_reset_urlend
  end
end
