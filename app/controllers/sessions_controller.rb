class SessionsController < ApplicationController
  layout "new-layout"

  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try :authenticate, params.dig(:session, :password)
      user_activated? user
    else
      flash.now[:danger] = t "flashes.danger.login_failure"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
