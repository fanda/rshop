# coding: utf-8

class Manage::Users::EmployeeController < ApplicationController

# controller for employee control in manage area
# RESTful methods are self-descriptive

  layout "manage"
  helper 'manage'
  helper 'errors'

  before_filter :require_employee
  before_filter :set_action


  def index
    @info = 'Jako zaměstnanec můžete měnit pouze své heslo'
    @title = 'Zaměstnanci obchodu'
    if flash[:success]
      @info = flash[:success]
    end
    @menu = [
    {:title=>'Přidat zaměstnance',  :href=>'/users/employee/new'}]
    @employees = Employee.paginate(:page=>params[:emp_page]||1,
                    :order=>'id DESC', :per_page => 10)   
  end

  def new
    @record = Employee.new
    render :partial => "form"
  end

  def create
    if params[:employee]
      @record = Employee.new(params[:employee])
      if @record.save
        flash[:success] = "Employee saved"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Employee was not saved"
            render :action => 'index'
          }
          format.js { render :partial => 'ajax_errors' }            
        end
      end  
    else
      redirect_to '/404.html' 
    end
  end

  def show
    @record = Employee.find_by_id params[:id]
    @info = 'Detaily zaměstnance'
    @title = "Informace o zaměstnanci #{@record.login}"
    redirect_to '/404.html' unless @record
  end

  def edit
    @record = Employee.find_by_id params[:id]
    render :partial => 'form'
  end

  def update 
    if params[:employee] and params[:id]
      @record = Employee.find_by_id params[:id]
      if @record.update_attributes params[:employee]
        flash[:success] = "Employee edited"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Employee was not edited"
            render :action => 'index'
          }
          format.js { render :partial => 'ajax_errors' }            
        end
      end  
    else
      redirect_to '/404.html' 
    end
  end

  def destroy
    record = Employee.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.destroy
    respond_to do |format|  
      flash[:error] = "Employee was removed"          
      format.html {         
        redirect_to :action => 'index' 
      }
      format.js {
        render :js => "window.location.href = \'./users/employee\';"
      }            
    end
  end


private

  def set_action
    @action = 'users'
  end

end
