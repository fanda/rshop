# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :right_side_content

protected

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

end
