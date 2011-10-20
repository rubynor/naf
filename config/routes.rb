Naf::Application.routes.draw do
  devise_for :user

  root :to => "test#index"

  match "/admin", :to => "admin/activities#index"
  match "/admin/access", :to => "admin/access#index"


  #scope for admin
  namespace :admin do
    resources :users, :activities, :locations
  end

  #scope used by the ext.js app
  scope "/rest" do
    resources :activities do
      get :search, :on => :collection
      post :file_upload, :on => :collection
    end
    resources :categories, :locations
  end

  resources :activities do
    get :search, :on => :collection
  end

  resources :locations, :categories, :activities
end
