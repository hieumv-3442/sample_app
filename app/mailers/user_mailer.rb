class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: (t "mailers.verify.subject")
  end
end
