require 'spec_helper'

describe Activity do
  disconnect_sunspot
  
  it "should embed a location" do
    relation = Activity.relations['location']
    relation.klass.should == (Location)
    relation.relation.should == (Mongoid::Relations::Embedded::One)
  end
  
  it "should embedd the location upon creation" do
    activity = Fabricate(:activity)
    activity.location.name.should == "NAF track Oslo"
  end
  
  it "should belongs to a" do
    relation = Activity.relations['category']
    relation.klass.should == (Category)
    relation.relation.should == Mongoid::Relations::Referenced::In
  end
  
  it "should embedd the category upon creation" do
    activity = Fabricate(:activity)
    activity.category.name.should == "Tracks"
  end
  
  it "sets dtend automatically if duration and dtstart is set"
  
end