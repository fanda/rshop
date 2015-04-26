# coding: utf-8
ActiveAdmin.register AdminUser do
  menu :parent => 'Uživatelé', :label => 'Zaměstnanci'

  filter :name
  filter :phone
  filter :email
  filter :created_at
  filter :last_sign_in_at

  index do
    column :name
    column :phone
    column :email
    actions
  end

  form do |f|
    f.inputs "Detaily" do
      f.input :name
      f.input :phone
      f.input :email
    end
    f.inputs "Heslo" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    panel "Detaily" do
      attributes_table_for admin_user do
        row('Name') { admin_user.name }
        row('Phone') { admin_user.phone }
        row('Email') { admin_user.email }
      end
    end
    panel "Přístupové informace" do
      attributes_table_for admin_user do
        row('Count of sign in') { admin_user.sign_in_count }
        row('Last sign in at') { admin_user.last_sign_in_at }
        row('Last sign in IP') { admin_user.last_sign_in_ip }
        row('Created at') { admin_user.created_at }
        row('Updated at') { admin_user.updated_at }
      end
    end
    active_admin_comments
  end
end
