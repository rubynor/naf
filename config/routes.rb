Naf::Application.routes.draw do
  devise_for :user

  root :to => "test#index"
  match "/admin", :to => "admin#index"

  #scope used by the ext.js app
  scope "/rest" do
    resources :activities, :categories, :locations
  end

  resources :activities do
    get :search, :on => :collection
    get :fields, :on => :collection
  end
  resources :locations, :categories
end
