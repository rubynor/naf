#encoding: UTF-8

require 'spec_helper'

describe Location do
  it "requires name, longitude, latitude and region" do
    Location.new.valid?.should be false
    Location.new(:name => "Location", :longitude => 60.6, :latitude => 3.4, :region => Fabricate(:region)).valid?.should be true
  end  
end