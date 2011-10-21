Eshop::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "catalog#index"

  resources :catalog,  :only => :show, :path => 'kategorie' do
    resources :product, :only => :show, :path => 'produkt'
  end

  controller :cart do
    match 'cart/submit',:to => :submit, :as => 'order', :via => [:put, :post]
    match 'cart/review',:to => :review
    match 'cart/clean', :to => :clean
    match 'cart/update/:id', :to => :update, :as => 'update_cart'
    match 'cart/remove/:id', :to => :remove, :as => 'remove_from_cart'
    match 'cart/add/:id', :to => :add, :as => 'into_cart'
    match 'cart/odorik', :to => :odorik, :as => 'odorik_pin_info', :via => :post
    match 'cart', :to => :index, :as => 'cart'
  end

  match 'manage' => 'manage#index'
  namespace :manage do
    controller :orders do
      #match '/orders', :to => :index
      match 'orders/waiting'     => 'orders#waiting'
      match 'orders/finished'    => 'orders#finished'
      #match 'orders/show/:id'    => 'orders#show'
      match 'orders/note/:id'    => 'orders#note'            
      match 'orders/state/:id'   => 'orders#state'
      match 'orders/item/:id'    => 'orders#item_note'
      match 'orders/status/:id'   => 'orders#status', :as => 'order_status'
      match 'orders/invoice/:id' => 'orders#invoice'
      match 'orders/invoice_address/:id' => 'orders#invoice_address'
    end
    resources :orders, :only => [:index, :show] do
      resources :invoices
    end
    namespace :catalog do
      resources :product do
        collection do
          post 'sort'
        end
      end
      resources :category do
        collection do
          get  'export'
          post 'import'
          get  'import'
          post 'sort'
        end
      end
      resources :supplier do
        resources :supply, :as => 'order', :path_names => { :edit => 'insert' }
      end
    end
    namespace :users do
      resources :customer, :employee
    end
    resources :catalog,    :only => :index
    resources :users,      :only => :index

    controller :statistics do
      match 'statistics/:count/months/:m(/:y)' => 'statistics#months'
      match 'statistics/month(/:m(/:y))' => 'statistics#month'
    end
    resources :statistics, :only => :index

    resources :pages, :except => [:show]
  end

  resources  :customer, :except => [:show, :destroy] do
    member do
      get 'password'
    end
  end
  controller :customer do
    match 'customer/order/:id', :to => :order, :as => 'customer_order'
    match 'customer/bill/:id', :to => :bill, :as => 'customer_bill'
    match 'login', :to => :login, :as => 'login'
    match 'logout', :to => :logout, :as => 'logout'
  end

  resources :employee, :only => :index do
    collection do
      get  'logout'
      get  'login'
      post 'login'
    end
  end

  match 'katalog.xml' => 'catalog#export', 
        :as => 'catalog_export',
        :defaults=>{:format=>'xml'}

  match 'kontakt' => 'pages#contact', :as => 'contact_form'

  match ':page_url' => 'pages#show', :constraints => {:page_url => /.*/}

  #match ':controller(/:action(/:id(.:format)))'
end
