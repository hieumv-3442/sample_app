class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :build_micropost, only: :create

  def create
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "flashes.success.created_micropost"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed, items:
        Settings.pagy.page_count_10
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "flashes.success.delete_micropost"
    else
      flash[:danger] = t "flashes.danger.delete_micropost"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "flashes.danger.micropost_not_found"
    redirect_to root_url, status: :see_other
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
  end
end
