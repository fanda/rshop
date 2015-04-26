# coding: utf-8
ActiveAdmin.register PaymentMethod do
  menu :priority => 7, :label => 'Způsoby platby'

  filter :cost

  index do
    column :name
    column :cost do |payment_method|
      div :class => "price" do
        number_to_currency payment_method.cost
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :cost
      f.input :info #, :as => :ckeditor
    end
    f.actions
  end

  show do

    panel payment_method.name do
      div :class => 'price' do
        number_to_currency payment_method.cost
      end
      div do
        simple_format payment_method.info
      end
    end
    active_admin_comments
  end

end
