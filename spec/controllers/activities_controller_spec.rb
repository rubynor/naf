require 'spec_helper'


describe ActivitiesController do
  disconnect_sunspot
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @category = Fabricate(:category)
    @location = Fabricate(:location)
  end
  
  it "creates an activity and return it as JSON" do
    post :create, {:activity => {:summary => "Learn to ride a car", :organizer_id => @location.id, :location_id => @location.id, :category_id => @category.id, :dtstart => Time.now, :dtend => Time.now + 3.days} }
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
    ActiveSupport::JSON.decode(response.body).should ==  ActiveSupport::JSON.decode({:activities => [activity1, activity2], :total => 2}.to_json)
  end
  
  it "should find all activities with pagination and return page count" do
    #{}"page"=>"1", "start"=>"0", "limit"=>"25"
    5.times{Fabricate(:activity, :summary => "Learn to slow dance")}
    get :index, :page => 1, :limit => 3
    ActiveSupport::JSON.decode(response.body)["activities"].size.should == 3
    get :index, :page => 1, :limit => 5
    ActiveSupport::JSON.decode(response.body)["activities"].size.should == 5
    ActiveSupport::JSON.decode(response.body)["total"].should == 5
  end
  
  
  it "should destroy an activity" do
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    Activity.all.size.should == 1
    delete :destroy, {:id => activity.id }
    Activity.all.size.should == 0
  end

  it "search actions should work (no real search performed here - se activities_search_spec)" do
    get :search
    ActiveSupport::JSON.decode(response.body).should == {"activities" => [], "total" => 0}
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    get :search, :text => "dance"
    ActiveSupport::JSON.decode(response.body).should == {"activities" => [], "total" => 0} #sunspot is mimiced with no results
  end
end
