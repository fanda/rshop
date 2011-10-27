ActiveAdmin.register Category do
  menu :parent => "Products"

  filter :parent
  filter :title

  index do
    column :title

    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :description
    end

    f.inputs "Taxonomy" do
      f.input :parent
    end
    f.buttons
  end

  show do
    panel "Details" do
      attributes_table_for category do
        row('Title') { category.title }
        row('Description') { category.description }
        row('Parent') { category.parent }
      end
    end
    active_admin_comments
  end
end
