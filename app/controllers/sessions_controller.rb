class SessionsController < ApplicationController
  layout "new-layout"

  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try :authenticate, params.dig(:session, :password)
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t ".incorrect"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
