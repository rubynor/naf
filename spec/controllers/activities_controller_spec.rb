require 'spec_helper'

describe ActivitiesController do
  
  it "creates an activity and return it as JSON" do
    @request.env["HTTP_ACCEPT"] = "application/json"
    post :create, {:activity => {:title => "Learn to ride a car"} }
    Activity.first.title.should == "Learn to ride a car"
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
end
