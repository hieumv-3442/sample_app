# frozen_string_literal: true

module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar.size}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def current_relationship user
    current_user.active_relationships.find_by(followed_id: user.id)
  end

  def new_active_relationship
    current_user.active_relationships.build
  end

  def can_delete_user? user
    current_user.admin && !current_user?(user)
  end
end
