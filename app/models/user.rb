class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :password, length: {minimum: Settings.min_length_password}
  validates :email, presence: true,
            length: {maximum: Settings.max_length_email},
            format: {with: Regexp.new(Settings.valid_email_regex, "i")},
            uniqueness: {case_sensitive: false}

  has_secure_password

  before_save :downcase_email
  before_create :generate_activation_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def feed
    Micropost.relate_post(following_ids << id).newest
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_send_at: Time.zone.now
    )
  end

  def send_password_reset_mail
    UserMailer.password_reset(self).deliver_now
  end

  def authenticated? attribute, remember_token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? remember_token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns activated: true
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  def password_reset_expired?
    reset_send_at < 2.hours.ago
  end

  def follow other_user
    following << other_user unless self == other_user
  end

  private
  def downcase_email
    email.downcase!
  end

  def generate_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
