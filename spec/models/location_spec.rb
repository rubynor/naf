require 'spec_helper'

describe Location do
  
  it "requires longitude and latitude" do
    Location.new.valid?.should be false
    Location.new(:longitude => 60.6, :latitude => 3.4).valid?.should be true
  end
  
end