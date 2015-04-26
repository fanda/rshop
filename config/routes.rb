Eshop::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "catalog#index"

  resources :catalog, :only => :show, :path => 'kategorie' do
    resources :product, :only => :show, :path => 'produkt'
  end
  resources :product, :only => :show, :path => 'produkt'

  controller :cart do
    match 'cart/submit',:to => :submit, :as => 'order', :via => [:put, :post]
    get 'cart/review',:to => :review
    get 'cart/clean', :to => :clean
    get 'cart/update/:id', :to => :update, :as => 'update_cart'
    get 'cart/remove/:id', :to => :remove, :as => 'remove_from_cart'
    get 'cart/add/:id', :to => :add, :as => 'into_cart'
    get 'cart', :to => :index, :as => 'cart'
  end

  devise_for :customers,
             :path => '', :skip => [:registrations, :sessions]

  devise_scope :customer do
    get  "login",  :to => "devise/sessions#new", :as => 'login'
    post "login",  :to => "devise/sessions#create"
    get  "logout", :to => "devise/sessions#destroy", :as => 'logout'

    post 'registrace', :to => "users/registrations#create"
    get  'registrace', :to => "users/registrations#new",    :as => 'register'
    put  'customer',   :to => "users/registrations#update"
    get  "customer/edit", :to => "devise/registrations#edit",:as => 'edit_customer'
  end

  resources  :customer, :only => [:index]
  controller :customer do
    get 'customer/order/:id', :to => :order, :as => 'customer_order'
    get 'customer/bill/:id', :to => :bill, :as => 'customer_bill'
  end

  get 'sitemap.xml' => 'pages#sitemap',
        :as => 'sitemap', :defaults=>{:format=>'xml'}

  get 'kontakt' => 'pages#contact', :as => 'contact_form'

  get ':page_url' => 'pages#show', :constraints => {:page_url => /.*/}

  #match ':controller(/:action(/:id(.:format)))'
end
