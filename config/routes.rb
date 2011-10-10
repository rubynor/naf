Naf::Application.routes.draw do
  root :to => "test#index"
  resources :activities do
    get :search, :on => :collection
    get :fields, :on => :collection
  end
  resources :locations, :categories
end
