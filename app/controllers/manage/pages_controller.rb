# coding: utf-8
class Manage::PagesController < ApplicationController

  layout "manage"

  before_filter :require_employee
  before_filter :set_action

  def index    
    @info = flash[:success]
    @title = 'Výpis zboží'

    @menu = [{:title=>'Přidat stránku',:href=>'/pages/new',:norel=>true}]
    
    @pages = Page.paginate(:page => params[:page]||1)
  end

  def new
    @record = Page.new
    render :action => "edit"
  end

  def create
    if params[:page]
      @record = Page.new(params[:page])
      if @record.save
        flash[:success] = "Stránka vytvořena"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { redirect_to :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Stránka nebyla vytvořena"
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
    @record = Page.find params[:id]
    @title = "Stránka #{@record.title}"    
    redirect_to '/404.html' unless @record
  end

  def edit
    @record = Page.find params[:id]
  end

  def update 
    if params[:page] and params[:id]
      @record = Page.find params[:id]
      if @record.update_attributes params[:page]
        flash[:success] = "Stránka upravena"
        redirect_to :action => 'index'
      else
        render :partial => 'form'
      end 
    else
      redirect_to '/404.html'
    end
  end

  def destroy
    Page.find(params[:id]).destroy
    respond_to do |format|  
      flash[:success] = "Stránka odstraněna"          
      format.html {         
        redirect_to :controller => manage_pages_path 
      }
      format.js {
        render :js => "window.location.reload();"
      }            
    end
  end


private

  def set_action
    @action = 'pages'
    @info = 'Informační stránky obchodu'
  end

end
