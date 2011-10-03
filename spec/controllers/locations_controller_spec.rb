require 'spec_helper'

describe LocationsController do
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
  end
  
  it "should find all locations" do
    location1 = Location.create(:name => "NAF center Oslo", :longitude => 30.3, :latitude => 6.5)
    location2 = Location.create(:name => "NAF center Trondheim", :longitude => 30.3, :latitude => 6.5)
    get :index
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode([location1, location2].to_json)
  end

end
