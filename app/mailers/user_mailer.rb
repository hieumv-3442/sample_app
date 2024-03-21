class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: (t "mailers.verify.subject")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t("mailers.reset_password.subject")
  end
end
