# coding: utf-8
ActiveAdmin.register Category do
  menu :label => 'Kategorie', :priority => 2

  filter :parent, :label => 'Nadkategorie'
  #filter :title, :label => 'Název'

  collection_action :index, :method => :get do
      scope = Category.roots

      @collection = scope.page() if params[:q].blank?
      @search = scope.ransack(clean_search_params(params[:q]))

      respond_to do |format|
        format.html {
          render "active_admin/resource/index"
        }
      end
  end

  action_item do
    link_to "View Site", "/"
  end

  #actions :all, :except => :new

  index do
    column :title do |c|
      if c.root?
        link_to(c.title, admin_category_path(c))
      else
        c.parent.title
      end
    end
    column 'Podkategorie' do |c|
      link_to(c.title, admin_category_path(c)) unless c.root?
    end
    actions
  end

  form do |f|
    f.inputs "Detaily" do
      f.input :title
      f.input :description
    end

    f.inputs "Taxonomie" do
      f.input :parent, :collection => Category.roots
    end
    f.actions
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
