require 'spec_helper'


describe ActivitiesController do
  disconnect_sunspot
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @category = Fabricate(:category)
    @location = Fabricate(:location)
  end
  
  it "creates an activity and return it as JSON" do
    post :create, {:activity => {:summary => "Learn to ride a car", :location_id => @location.id, :category_id => @category.id} }
    Activity.first.summary.should == "Learn to ride a car"
    ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "updates an activity and returns it as JSON" do
    activity = Fabricate(:activity, :summary => "Learn to slow dance")
    Activity.first.summary.should == "Learn to slow dance"
    put :update, {:activity => {:summary => "Learn to dance fast"}, :id => activity.id }
    Activity.first.summary.should == "Learn to dance fast"
    ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "should find and activity based on id" do
    activity = activity = Fabricate(:activity, :summary => "Learn to ride a horse")
    get :show, {:id => activity.id }
    ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode(Activity.first.to_json)
  end
  
  it "should find all activities" do
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance")
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance fast")
    get :index
    ActiveSupport::JSON.decode(response.body).should ==  ActiveSupport::JSON.decode({:activities => [activity1, activity2]}.to_json)
  end
  
  
  it "should destroy an activity" do
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    Activity.all.size.should == 1
    delete :destroy, {:id => activity.id }
    Activity.all.size.should == 0
  end
  
  it "should find activity based on search" do
    get :search
    ActiveSupport::JSON.decode(response.body).should == {"activities" => []}
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    get :search, :text => "dance"
    ActiveSupport::JSON.decode(response.body).should == {"activities" => []} #sunspot is mimiced with no results
  end
end
