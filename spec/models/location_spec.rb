#encoding: UTF-8

require 'spec_helper'

describe Location do
  
  it "requires name, longitude, latitude and region" do
    Location.new.valid?.should be false
    Location.new(:name => "Location", :longitude => 60.6, :latitude => 3.4, :region => Fabricate(:region)).valid?.should be true
  end
  
  it "should order locations on region" do
    
    2.times{Location.create(:name => "Location", :longitude => 60.6, :latitude => 3.4, :region => Fabricate(:region, :name => "Sør"))}
    2.times{Location.create(:name => "Location", :longitude => 60.6, :latitude => 3.4, :region => Fabricate(:region, :name => "Nord"))}
    2.times{Location.create(:name => "Location", :longitude => 60.6, :latitude => 3.4, :region => Fabricate(:region, :name => "Øst"))}
    Location.all[0].region.name.should == "Sør"
    Location.by_region[0].region.name.should == "Nord"
    Location.by_region[1].region.name.should == "Nord"
    Location.by_region[2].region.name.should == "Sør"
    Location.by_region[3].region.name.should == "Sør"
    Location.by_region[4].region.name.should == "Øst"
    Location.by_region[5].region.name.should == "Øst"
  end
end