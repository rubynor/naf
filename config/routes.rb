# -*- encoding : utf-8 -*-
Naf::Application.routes.draw do
  devise_for :user

  root :to => "test#index"

  match "/admin", :to => "admin/activities#index"
  match "/admin/access", :to => "admin/access#index"
  match "/admin/upload", :to => "admin/activities#file_upload"

  #scope for admin
  namespace :admin do
    resources :users, :locations
    resources :activities do
      get :copy, :on => :member
      post :file_upload
      get :search, :on => :collection
    end
  end
  resources :locations, :categories, :activities

end
