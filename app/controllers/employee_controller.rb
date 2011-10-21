class EmployeeController < ApplicationController

# employee session management (logging in, logging out)

  before_filter :require_no_employee, :only => :login
  before_filter :require_employee, :only => :logout

  def index
    if current_employee
      redirect_to '/manage'
    else
      @employee = EmployeeSession.new      
      render :layout => 'employee_login'
    end
  end

  def logout
    current_employee_session.destroy
    flash[:notice] = "Logout successful!"  
    redirect_back_or_default '/'
  end

  def login
    if request.post?
      @employee = EmployeeSession.new(params[:employee_session])
      if @employee.save
        redirect_to '/manage'
      else
        render :layout => 'employee_login', :action => 'index'
      end
    else
      redirect_to :action => 'index'
    end
  end

end
