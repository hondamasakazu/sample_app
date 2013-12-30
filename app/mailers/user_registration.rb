class UserRegistration < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_registration.sendmail_confirm.subject
  #
  def sendmail_confirm(user)
    @greeting = "こんにちは！#{user.name}"
    @user = user
    mail(:to => user.email, :subject => "Welcome to My Awesome Site") do |format|
      format.html
    end
  end
end
