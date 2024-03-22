class StaticPagesController < ApplicationController
  layout "new-layout"

  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, items:
      Settings.pagy.page_count_10
  end

  def help; end
end
