class SessionsController < ApplicationController
  layout 'new-layout'

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t"flashes.danger.login_failure"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
