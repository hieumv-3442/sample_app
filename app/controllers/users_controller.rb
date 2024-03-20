class UsersController < ApplicationController
  layout 'new-layout'
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @pagy, @users = pagy(User.all, items: 10)
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('flashes.success.update_user')
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('flashes.danger.update_user', count: @user.errors.count)
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t('flashes.success.welcome', user_name: @user.name)
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('flashes.danger.data_invalid', count: @user.errors.count)
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t('flashes.danger.user_not_found')
    redirect_to root_path
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      store_location
      redirect_to login_path
    end
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = I18n.t('flashes.danger.not_authorized')
    redirect_to root_path
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('flashes.success.user_deleted')
    else
      flash[:danger] = I18n.t('flashes.danger.user_not_deleted')
    end
    redirect_to users_url
  end

  private
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
