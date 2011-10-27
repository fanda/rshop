ActiveAdmin.register Supply do

  belongs_to :supplier

  form do |f|
    f.inputs "Details" do
      f.input :supplier
      f.input :delivered_at
    end
    f.input :supplier do |supplier|
      f.input :products, :as => :check_boxes, :collection => supplier.products
    end
    f.buttons
  end

end
