class UserMailer < ApplicationMailer

  def invite email, team, user
    @team = team
    @user = user

    mail to: email
  end
end
