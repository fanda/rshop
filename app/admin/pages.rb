ActiveAdmin.register Page do
  menu :priority => 7

  filter :title
  filter :created_at

  index do
    column 'Title' do |page|
      link_to page.title, "/#{page.url}"
    end

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
    end
    f.buttons
  end

  show do
    panel 'Details' do
      attributes_table_for page do
        row('Title') { link_to page.title, "/#{page.url}" }
        row('Body') { page.body }
      end
    end
    active_admin_comments
  end

end
