class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.project_expired_notice.subject
  #
  def project_expired_notice
    @project = params[:project]

    mail to: @project.user.email, subject: "Your project has expired!"
  end
end
