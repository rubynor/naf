Naf::Application.routes.draw do
  devise_for :models

  root :to => "test#index"
  match "/admin", :to => "admin#index"

  scope "/rest" do
    resources :activities, :categories, :locations
  end

  resources :activities do
    get :search, :on => :collection
    get :fields, :on => :collection
  end
  resources :locations, :categories
end
