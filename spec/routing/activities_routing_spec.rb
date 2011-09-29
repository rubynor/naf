require 'spec_helper'

describe "routing to activities" do
  it "routes /activities to activities#index" do
    { :get => "/activities" }.should route_to(
      :controller => "activities",
      :action => "index"
    )
  end
  it "routes /activities/:id to activities#show for id" do
    { :get => "/activities/1" }.should route_to(
      :controller => "activities",
      :action => "show",
      :id => "1"
    )
  end
  it "routes /activities/:id to activities#update for id" do
    { :put => "/activities/1" }.should route_to(
      :controller => "activities",
      :action => "update",
      :id => "1"
    )
  end
  it "routes /activities to activities#create for post" do
    { :post => "/activities" }.should route_to(
      :controller => "activities",
      :action => "create"
    )
  end
  
  it "routes /activities to activities#destroy for id" do
    { :delete => "/activities/1" }.should route_to(
      :controller => "activities",
      :action => "destroy",
      :id => "1"
    )
  end
end