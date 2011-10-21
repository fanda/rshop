# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session,     :current_user,
                :current_employee_session, :current_employee


  def dbg item
    @debug ||=[]
    @debug << item
  end

  def shorten(string, word_limit = 5)
    words = string.split(/\s/)
    if words.size >= word_limit
       last_word = words.last
       words[0,(word_limit-1)].join(" ") + '...' + last_word
    else
      string
    end
  end

  # get last product, list of categories and suppliers for layout
  def right_side_content
    @categories = Category.roots
    @title = "Internetový obchod Odorik"
    @meta_desc=''
  end


  def no_layout_if_xhr_request
    if request.xhr?
      render :layout => false
    end
  end

protected

  # methods for back redirecting

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # methods for customer session management

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = CustomerSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:error] = "Přihlášení nebylo úspěšné. Zkuste to znovu."
      redirect_to '/login'
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to '/404.html'
      return false
    end
  end

  # methods for employee session management

  def current_employee_session
    return @current_employee_session if defined?(@current_employee_session)
    @current_employee_session = EmployeeSession.find
  end

  def current_employee
    return @current_employee if defined?(@current_employee)
    @current_employee = current_employee_session && current_employee_session.record
  end

  def require_employee
    unless current_employee
      store_location
      flash[:error] = "Přihlášení nebylo úspěšné. Zkuste to znovu."
      redirect_to '/employee'
      return false
    end
  end

  def require_no_employee
    if current_employee
      store_location
      redirect_to '/404.html'
      return false
    end
  end
end
