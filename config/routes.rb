Naf::Application.routes.draw do
  resources :activities do
    get :search, :on => :collection
  end
  resources :locations, :categories
end
