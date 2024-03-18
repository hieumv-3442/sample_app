class UsersController < ApplicationController
  layout 'new-layout'
  before_action :load_user, only: [:show]

  def new
    @user = User.new
  end

  def show; end

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

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t('flashes.danger.user_not_found')
    redirect_to root_path
  end
end
