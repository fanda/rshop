# coding: utf-8
ActiveAdmin.register Category do
  menu false #:parent => "Produkty", :label => 'Kategorie'

  filter :parent
  #filter :title

  controller do
    def index
      @categories = Category.page(params[:page]||1)
    end
  end

  index do
    column :title

    default_actions
  end

  form do |f|
    f.inputs "Detaily" do
      f.input :title
      f.input :description
    end

    f.inputs "Taxonomie" do
      f.input :parent, :collection => Category.roots
    end
    f.buttons
  end

  show do
    panel "Detaily" do
      attributes_table_for category do
        row('Title') { category.title }
        row('Description') { category.description }
        row('Parent') { category.parent }
      end
    end
    active_admin_comments
  end
end
