#encoding: UTF-8

require 'spec_helper'

describe Admin::LocationsController do
  render_views
  
  it "raises error if non superadmin tries to access locations controller" do
    sign_in Fabricate(:user, :super_admin => false)
    expect {get :index}.to raise_exception "No access"
  end
  
  it "renders OK if user is superadmin" do
    sign_in Fabricate(:user, :super_admin => true)
    get :index
    response.should render_template "admin/locations/index"
    response.should render_template "layouts/admin"
  end
  
  context "crude" do
    before(:each) do
      sign_in Fabricate(:user, :super_admin => true)
    end
    
    it "shows the location" do
      get :show, :id => Fabricate(:location, :name => "location A").id
      response.should render_template "admin/locations/show"
      response.body.should include("location A")
    end

    it "shows the edit location page" do
      get :edit, :id => Fabricate(:location, :name => "location A").id
      response.should render_template "admin/locations/edit"
      response.body.should include("location A")
    end

    it "updates a location, redirects to show page " do
      @location =  Fabricate(:location, :name => "location A")
      put :update, :id => @location.id, :location => {:name => "Location A changed"}
      Location.find(@location.id).name.should == "Location A changed"
      response.should redirect_to admin_location_url(@location)
    end

    it "renders edit page on failed update and shows a notice" do
      @location =  Fabricate(:location, :name => "location A")
      put :update, :id => @location.id, :location => {:name => ""}
      response.should render_template "admin/locations/edit"
      response.body.should include("Navn kan ikke være blank")
    end

    it "renders the new page" do
      get :new
      response.should render_template "admin/locations/new"
    end
    
    it "creates a location and shows it" do
      post :create, :location => {:name => "Location B", :latitude => 10, :longitude => 20, :region_id => Fabricate(:region).id}
      Location.where(:name => "Location B").size.should == 1
      response.should redirect_to admin_location_url(Location.where(:name => "Location B").first)
    end
    
    it "destroys a location and redirects to index" do
      Location.destroy_all
      @location = Fabricate(:location)
      delete :destroy, :id => @location.id
      Location.all.size.should == 0
      response.should redirect_to admin_locations_url
    end
  end
end