# coding: utf-8
class Manage::Users::CustomerController < ApplicationController

# controller for customer control in manage area
# RESTful methods are self-descriptive

  layout "manage"
  helper 'manage'
  helper 'errors'

  before_filter :require_employee
  before_filter :set_action

  def index
    @info  = 'Nemůžete měnit hesla zákazníků'

    @title = 'Naši zákazníci'

    if flash[:success]
      @info = flash[:success]
    end

    @menu = [{:title=>'Přidat zákazníka', :href=>'/users/customer/new'}]

    @customers = Customer.paginate(:page=>params[:cus_page]||1,
                    :order=>'id DESC', :per_page => 10)    
  end

  def new
    @record = Customer.new
    render :partial => "form"
  end

  def create
    if params[:customer]
      @record = Customer.new(params[:customer])
      if @record.save
        flash[:success] = "Customer saved"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Customer was not saved"
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
    @info = 'Toto je samostatná stránka zákazníka v administraci'
    @record = Customer.find_by_id params[:id]
    @title = "Zákazník #{@record.login}"
    redirect_to '/404.html' unless @record
  end

  def view
    @record = Customer.find_by_id params[:id]
    unless @record
      redirect_to '/404.html'
    else
      render :layout => nil, :action => 'show'
    end
  end


  def edit
    @record = Customer.find_by_id params[:id]
    render :partial => 'form'
  end

  def update 
    if params[:customer] and params[:id]
      @record = Customer.find_by_id params[:id]
      if @record.update_attributes params[:customer]
        current_user_session.destroy
        flash[:success] = "Customer edited"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Customer was not edited"
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
    record = Customer.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.destroy
    respond_to do |format|  
      flash[:error] = "Customer was removed"          
      format.html {         
        redirect_to :action => 'index' 
      }
      format.js {
        render :js => "window.location.href = \'./users/customer\';"
      }            
    end
  end


private

  def set_action
    @action = 'users'
  end

end
