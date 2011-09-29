require 'spec_helper'

describe ActivitiesController do
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
  end
  
  it "creates an activity and return it as JSON" do
    post :create, {:activity => {:title => "Learn to ride a car"} }
    Activity.first.title.should == "Learn to ride a car"
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "updates an activity and returns it as JSON" do
    activity = Activity.create(:title => "Learn to slow dance")
    Activity.first.title.should == "Learn to slow dance"
    put :update, {:activity => {:title => "Learn to dance fast"}, :id => activity.id }
    Activity.first.title.should == "Learn to dance fast"
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "should find and activity based on id" do
    activity = Activity.create(:title => "Learn to ride a horse")
    get :show, {:id => activity.id }
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "should find all activities" do
    activity1 = Activity.create(:title => "Learn to steal a wallet")
    activity2 = Activity.create(:title => "Learn to give it back")
    get :index
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode([activity1, activity2].to_json)
  end
  
end
