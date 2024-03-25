class UsersController < ApplicationController
  layout "new-layout"
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @pagy, @users = pagy(User.all, items: Settings.pagy.page_count_10)
  end

  def show
    @pagy, @microposts = pagy @user.feed, items: Settings.pagy.page_count_10
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "flashes.success.update_user"
      redirect_to @user
    else
      flash.now[:danger] = t "flashes.danger.update_user",
                             count: @user.errors.count
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_mail_activate
      flash[:info] = t "flashes.info.request_verify"
      redirect_to @user
    else
      flash.now[:danger] = t "flashes.danger.data_invalid",
                             count: @user.errors.count
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flashes.success.user_deleted"
    else
      flash[:danger] = t "flashes.danger.user_not_deleted"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "flashes.danger.user_not_found"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "flashes.danger.not_authorized"
    redirect_to root_path
  end
end
