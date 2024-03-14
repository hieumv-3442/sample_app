class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :password, length: {minimum: Settings.min_length_password}
  validates :email, presence: true, length: {maximum: Settings.max_length_email},
            uniqueness: true,
            format: {with: Regexp.new(Settings.min_length_password, "i")}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
