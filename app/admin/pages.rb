# coding: utf-8
ActiveAdmin.register Page do
  menu :priority => 7, :label => 'Stránky'

  filter :title
  filter :created_at

  index do
    column :title do |page|
      link_to page.title, "/#{page.url}"
    end

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :body #, :as => :ckeditor
    end
    f.buttons
  end

  show do
    panel 'Details' do
      attributes_table_for page do
        row('Titulek') { link_to page.title, "/#{page.url}" }
        row('Tělo stránky') { page.body.html_safe }
      end
    end
    active_admin_comments
  end

end
