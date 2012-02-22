# coding: utf-8
require 'csv'
ActiveAdmin.register Product do
  menu :priority => 2, :label => 'Produkty'

  scope :active
  scope :inactive
  scope :without_category

  filter :category
  #filter :supplier
  filter :title, :label => 'Název'
  filter :amount
  filter :price
  filter :created_at

  collection_action :import_csv, :method => :post do
    unless params[:file]
      redirect_to :action => :index
      return
    end
    counter = 1
    begin
      csv = CSV.parse(params[:file].read, :headers => true)
      csv.each do |row|
        row = row.to_hash.with_indifferent_access
        unless Product.find_by_title(row['title'])
          Product.create!(row.to_hash.symbolize_keys)
        end
        counter += 1
      end
      flash[:notice] = 'Produkty importovány'
    rescue
      flash[:error] = "Chyba při importu na #{counter}. řádku"
    end
    redirect_to :action => :index
  end

  sidebar :import, :only => :index, :partial => "import"

  action_item :only => :show do
    link_to "Vytvořit", new_admin_product_path
  end

  index do
    column :name do |product|
      link_to product.name, admin_product_path(product)
    end
    column :category
   # column :supplier
    column :amount
    column :price, :sortable => :price do |product|
      div :class => "price" do
        number_to_currency product.price
      end
    end
    default_actions
  end

  form do |f|
    f.inputs "Podrobnosti" do
      f.input :title
      f.input :description
      f.input :category
      #f.input :supplier
    end

    f.inputs "Sklad" do
      f.input :amount
      f.input :price
      f.input :active, :as => :boolean, :label => 'V katalogu'
    end

    f.inputs 'Obrázek' do
      f.input :picture, :as => :file
    end
    f.buttons
  end

  show do
    panel "Podrobnosti" do
      attributes_table_for product do
        row :title
        row :description
        row :category
        #row :supplier
      end
    end

    panel "Sklad" do
      attributes_table_for product do
        row :amount
        row :price
        row :updated_at
        row 'Počet prodaných kusů' do
          product.counter
        end
        row 'V katalogu' do
          if product.active?
            status_tag 'Zobrazen', :ok
          else
            status_tag 'Nezobrazen', :error
          end
        end
      end
    end

    panel 'Obrázek' do
      div { image_tag product.picture.url }
    end
    active_admin_comments
  end
end
