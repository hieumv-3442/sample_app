# frozen_string_literal: true

module UsersHelper
  def gravatar_for user, options = {size: Settings.img.size_80}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def can_delete_user? user
    current_user.admin && !current_user?(user)
  end
end
