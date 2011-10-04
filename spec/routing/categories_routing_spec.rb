require 'spec_helper'

describe "routing to categories" do
  it "routes /categories to categories#index" do
    { :get => "/categories" }.should route_to(
      :controller => "categories",
      :action => "index"
    )
  end
end