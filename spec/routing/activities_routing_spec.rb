require 'spec_helper'

describe "routing to activities" do
  it "routes /admin/activities to activities#index" do
    { :get => "/admin/activities" }.should route_to(
      :controller => "admin/activities",
      :action => "index"
    )
  end
  it "routes /admin/activities/:id to activities#show for id" do
    { :get => "/admin/activities/1" }.should route_to(
      :controller => "admin/activities",
      :action => "show",
      :id => "1"
    )
  end
  it "routes /admin/activities/:id to activities#update for id" do
    { :put => "/admin/activities/1" }.should route_to(
      :controller => "admin/activities",
      :action => "update",
      :id => "1"
    )
  end
  it "routes /admin/activities to activities#create for post" do
    { :post => "/admin/activities" }.should route_to(
      :controller => "admin/activities",
      :action => "create"
    )
  end
  
  it "routes /admin/activities to activities#destroy for id" do
    { :delete => "/admin/activities/1" }.should route_to(
      :controller => "admin/activities",
      :action => "destroy",
      :id => "1"
    )
  end
end