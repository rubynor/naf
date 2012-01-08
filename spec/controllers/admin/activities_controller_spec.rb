# -*- encoding : utf-8 -*-

require 'spec_helper'

describe Admin::ActivitiesController do
  disconnect_sunspot
  
  before(:each) do
    sign_in Fabricate(:user)
    @category = Fabricate(:category)
    @location = Fabricate(:location)
  end
  
  it "redirects if there is no user" do
    sign_out User.first
    get :index
    response.should redirect_to "/user/sign_in"
  end
  
  it "grant access when user is logged in" do
    sign_in Fabricate(:user)
    get :index
    response.should render_template "admin/activities/index"
    response.should render_template "layouts/admin"
  end
  
  it "creates an activity and redirects to show path" do
    post :create, {:activity => {:summary => "Learn to ride a car", :organizer_id => @location.id, :location_id => @location.id, :category_id => @category.id, :dtstart => Time.now, :dtend => Time.now + 3.days}}
    Activity.first.summary.should == "Learn to ride a car"
    response.should redirect_to(admin_activity_url(Activity.first))
  end
  
  it "updates an activity and redirects to show path" do
    activity = Fabricate(:activity, :summary => "Learn to slow dance")
    Activity.first.summary.should == "Learn to slow dance"
    put :update, {:activity => {:summary => "Learn to dance fast"}, :id => activity.id }
    Activity.first.summary.should == "Learn to dance fast"
    response.should redirect_to(admin_activity_url(Activity.first))
  end
  
  it "should find and activity based on id" do
    activity = activity = Fabricate(:activity, :summary => "Learn to ride a horse")
    get :show, {:id => activity.id }
    response.should render_template "show"
  end
  
  it "should find all activities" do
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance")
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance fast")
    get :index
    response.should render_template "index"
  end
  
  it "should find all activities with pagination and return page count" do
    #{}"page"=>"1", "start"=>"0", "limit"=>"25"
    5.times{Fabricate(:activity, :summary => "Learn to slow dance")}
    get :index, :page => 1, :limit => 3, :format => :json
    ActiveSupport::JSON.decode(response.body)["activities"].size.should == 3
    get :index, :page => 1, :limit => 5, :format => :json
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
    get :search, :format => :json
    ActiveSupport::JSON.decode(response.body).should == {"activities" => [], "total" => 0}
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    get :search, :text => "dance", :format => :json
    ActiveSupport::JSON.decode(response.body).should == {"activities" => [], "total" => 0} #sunspot is mimiced with no results
  end
end
