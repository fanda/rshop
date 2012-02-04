# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :right_side_content, :set_locale

protected

  def set_locale
    I18n.default_locale = :cz
    I18n.locale = :cz
  end

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
    @title = "Internetový obchod"
    @meta_desc=''
  end


  def no_layout_if_xhr_request
    if request.xhr?
      render :layout => false
    end
  end

  # methods for back redirecting

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_user
    current_customer
  end

  def render_page_not_found
    render :template => '/pages/notfound', :layout => 'error', :status => 404
  end

protected

  def ckeditor_filebrowser_scope(options = {})
    super(
     {:assetable_id => current_manager.id,
      :assetable_type => 'Manager' }.merge(options)
    )
  end

  def ckeditor_pictures_scope(options = {})
    ckeditor_filebrowser_scope(options)
  end

  def ckeditor_attachment_files_scope(options = {})
    ckeditor_filebrowser_scope(options)
  end
end
