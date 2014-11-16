class UserMailer < ActionMailer::Base
  default from: 'payments@getsprk.com'

  def payment_general(id, amount)
    @user = User.find(id)
    @amount = amount
    mail to: @user.email, subject: "Payment received for your appointment!"
  end
end
