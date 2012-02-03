# coding: utf-8
class OrderMailer < ActionMailer::Base
  default :from => AppConfig.email
  add_template_helper(ApplicationHelper)

  def new_customer(customer, password)
    @customer = customer
    @pass = password

    mail(
      :to => customer.email,
      :subject => 'Vytvoření zákaznického účtu v obchodě') do |format|
        format.text
    end
  end

  def new_order(customer, order)
    @customer = customer
    @order = order

    mail(
      :to => AppConfig.email,
      :subject => "Nová objednávka - #{AppConfig.long_title}") do |format|
        format.text
    end
  end

  def review_order(customer, order)
    @customer = customer
    @order = order

    mail(
      :to => customer.email,
      :subject => "Nová objednávka - #{AppConfig.long_title}") do |format|
        format.text
    end
  end

end
