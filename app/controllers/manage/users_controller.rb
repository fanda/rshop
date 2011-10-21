# coding: utf-8
class Manage::UsersController < ApplicationController

# default controller for user managing

  layout "manage"
  helper 'manage'
  helper "errors"

  before_filter :require_employee
  before_filter :set_action


  def index
    @info = 'Uživatelé se dále dělí na zaměstnance a zákazníky'
    @title = 'Uživatelé systému'
    @menu = [
    {:title=>'Přidat zaměstnance', :href=>'/users/employee/new'},
    {:title=>'Přidat zákazníka', :href=>'/users/customer/new'}]
    
    @customers = Customer.paginate(:page=>params[:cus_page]||1,:order=>'id DESC')
    @employees = Employee.paginate(:page=>params[:emp_page]||1,:order=>'id DESC')

  end

private

  def set_action
    @action = 'users'
  end

end
