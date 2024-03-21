module SessionsHelper
  def log_in user
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token], :remember)
        log_in user
        @current_user = user
      end
    end
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logged_in?
    current_user.present?
  end

  def user_activated? user
    if user.activated?
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "flashes.warning.account_not_activated"
      render :new, status: :forbidden
    end
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def current_user? user
    user && user == current_user
  end

  def redirect_back_or default
    forwarding_url = session[:forwarding_url]
    session.delete :forwarding_url
    redirect_to forwarding_url || default
  end
end
