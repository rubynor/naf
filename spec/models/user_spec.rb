require 'spec_helper'

describe User do
  
  context "validation" do
    it "is invalid if no region, no location and not superadmin" do
      user = User.new(:email => "hello@rubynor.no", :password => "secret", :password_confirmatin => "secret", :super_admin => false, :region => nil, :location => nil)
      user.valid?.should be_false
    end
    
    it "is valid if no region, no location and IS superadmin" do
      Fabricate(:user, :super_admin => true, :region => nil, :location => nil).valid?.should be_true
    end
    
    it "is valid if HAS region, no location and not superadmin" do
      Fabricate(:user, :super_admin => false, :region => Fabricate(:region), :location => nil).valid?.should be_true
    end
    
    it "is valid if no region, HAS location and not superadmin" do
      Fabricate(:user, :super_admin => false, :region => nil, :location => Fabricate(:location)).valid?.should be_true
    end
    
    
  end
  
  describe "editable locations" do

    it "is the location_id if the location has no children" do
      user = Fabricate(:user)
      location = Fabricate(:location)
      user = Fabricate(:user, :location => location)
      user.editable_locations.should == [location.id.to_s]
    end
    
    it "is the location and the location children if the location has children" do
      user = Fabricate(:user)
      location = Fabricate(:location)
      
      sub_location1 = Fabricate(:location, :location => location)
      sub_location2 = Fabricate(:location, :location => location)
      
      user = Fabricate(:user, :location => location)
      user.editable_locations.should == [location.id.to_s, sub_location1.id.to_s, sub_location2.id.to_s]
    end
    
    it "is the regions location ids if the user has a region" do
      region = Fabricate(:region)
      user = Fabricate(:user, :region => region)
      location = Fabricate(:location, :region => region)
      user.editable_locations.should == [location.id.to_s]
    end
    
    it "is the regions location ids and the locations children ids if the location got children" do
      region = Fabricate(:region)
      user = Fabricate(:user, :region => region)
      location = Fabricate(:location, :region => region)
      sub_location = Fabricate(:location, :location => location)
      user.editable_locations.should == [location.id.to_s, sub_location.id.to_s]
    end
    
  end
end
