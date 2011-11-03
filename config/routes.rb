Eshop::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "catalog#index"

  resources :category, :as => "catalog",  :only => :show, :path => 'kategorie' do
    resources :product, :only => :show, :path => 'produkt'
  end
  resources :product, :only => :show, :path => 'produkt'
  controller :cart do
    match 'cart/submit',:to => :submit, :as => 'order', :via => [:put, :post]
    match 'cart/review',:to => :review
    match 'cart/clean', :to => :clean
    match 'cart/update/:id', :to => :update, :as => 'update_cart'
    match 'cart/remove/:id', :to => :remove, :as => 'remove_from_cart'
    match 'cart/add/:id', :to => :add, :as => 'into_cart'
    match 'cart', :to => :index, :as => 'cart'
  end

  devise_for :customer, :skip => [:registrations, :sessions] do
    get  "login", :to => "devise/sessions#new", :as => 'login'
    post "login", :to => "devise/sessions#create"
    get "logout", :to => "devise/sessions#destroy", :as => 'logout'

    get  "register", :to => "devise/registrations#new", :as => 'register'
    post "register", :to => "devise/registrations#create"
    get  "customer/edit", :to => "devise/registrations#edit",:as => 'edit_customer'
    put  "customer", :to => "devise/registrations#update"
  end
  resources  :customer, :only => [:index]
  controller :customer do
    match 'customer/order/:id', :to => :order, :as => 'customer_order'
    match 'customer/bill/:id', :to => :bill, :as => 'customer_bill'
  end

  match 'heureka.xml' => 'catalog#export',
        :as => 'catalog_export',
        :defaults=>{:format=>'xml'}

  match 'kontakt' => 'pages#contact', :as => 'contact_form'

  match ':page_url' => 'pages#show', :constraints => {:page_url => /.*/}

  #match ':controller(/:action(/:id(.:format)))'
end
