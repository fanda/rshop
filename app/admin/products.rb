# coding: utf-8
require 'csv'
ActiveAdmin.register Product do
  menu :priority => 2, :label => 'Produkty'
  #belongs_to :category
  scope :active
  scope :inactive
  scope :without_category

  filter :category, :label => 'Kategorie'
  #filter :supplier
  #filter :title
  filter :amount
  filter :price
  filter :created_at

  collection_action :import_csv, :method => :post do
=begin
    unless params[:file]
      redirect_to :action => :index
      return
    end
    csv_text = File.read(params[:file].read)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      flash[:notice] = row.inspect!
      Product.create!(row.to_hash.symbolize_keys)
    end
=end
    flash[:error] = "Ještě není implementováno"
    redirect_to :action => :index
  end

  sidebar :import, :only => :index, :partial => "import"

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
        row 'Počet objednávek' do
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
