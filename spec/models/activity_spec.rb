require 'spec_helper'

describe Activity do

  it "should embed a location" do
    relation = Activity.relations['location']
    relation.klass.should == (Location)
    relation.relation.should == (Mongoid::Relations::Embedded::One)
  end
  
  it "should embedd the location upon creation" do
    activity = Fabricate(:activity)
    activity.location.name.should == "NAF track Oslo"
  end
  
  it "should embed a category" do
    relation = Activity.relations['categories']
    relation.klass.should == (Category)
    relation.relation.should == (Mongoid::Relations::Embedded::Many)
  end
  
  it "should embedd the category upon creation" do
    activity = Fabricate(:activity)
    activity.categories.first.name.should == "Tracks"
  end
  
  it "sets dtend automatically if duration and dtstart is set"
  
end