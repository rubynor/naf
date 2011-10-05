Naf::Application.routes.draw do
  resources :activities do
    get :search, :on => :collection
    get :fields, :on => :collection
  end
  resources :locations, :categories
end
