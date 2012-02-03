# coding: utf-8
class ContactMailer < ActionMailer::Base

  def question(params)
    @name     = params[:name]
    @email    = params[:email]
    @phone    = params[:phone]
    @question = params[:question]

    mail(
      :to => AppConfig.email,
      :from => @email,
      :subject => 'Dotaz od zákazníka obchodu') do |format|
        format.text
    end
  end

end
