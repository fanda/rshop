# coding: utf-8
ActiveAdmin.register_page "Help", :label => "Nápověda" do

  menu :label => 'Nápověda'

  sidebar :summary, :label => 'Obsah' do
    ul do
      li(link_to "Import produktů", '#product_import')
    end
  end

  content do
    render 'content'
  end
end
