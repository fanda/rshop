module ManageHelper

  def top_navigation
     pages = ['index','catalog','users','orders','pages','statistics']
     pages.each_with_index do |page, i|
        href = i == 0 ? '/' : "/#{page}"
        title = i == 0 ? 'Home' : page.capitalize
        if @action == page
          concat content_tag :li, link_to(title,"/manage#{href}",:class=>'active')
        else
          concat content_tag :li, link_to(title,"/manage#{href}")
        end
     end
     concat content_tag :li, link_to('Show shop',"/")
     concat content_tag :li, link_to('Logout',"/employee/logout")
     nil
  end

  def navigation
    @menu.each do |item|
       rel = item[:norel] ? nil : 'facebox'
       nsp = item[:noprefix] ? nil : '/manage'
       concat content_tag :li, 
              link_to(item[:title],"#{nsp}#{item[:href]}", :rel => rel, :method => item[:method])
     end
    nil
  end
end
