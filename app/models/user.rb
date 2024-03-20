class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :password, length: {minimum: Settings.min_length_password}
  validates :email, presence: true, length: {maximum: Settings.max_length_email},
            uniqueness: true,
            format: {with: Regexp.new(Settings.valid_email_regex, "i")}

  has_secure_password

  before_save :downcase_email

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated?(remember_token)
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    email.downcase!
  end
end
