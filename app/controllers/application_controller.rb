class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "signin.request_login"
    store_location
    redirect_to login_path
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
