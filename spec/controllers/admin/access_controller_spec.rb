require 'spec_helper'

describe Admin::AccessController do
  
  it "renders nothing if there is no user" do
    get :index
    response.body.should be_blank
  end
  
  context "user is present" do
    
    it "returns the ids of the locations a user can manage" do
      @location = Fabricate(:location)
      sign_in Fabricate(:user, :location_id => @location.id)
      get :index
      response.body.should == [@location.id.to_s].to_json
    end
  
    it "returns a flag if user is super admin" do
      sign_in Fabricate(:user, :super_admin => true)
      get :index
      response.body.should == "super"
    end
  end
  
  
end