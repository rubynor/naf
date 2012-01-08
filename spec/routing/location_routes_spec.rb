# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "routing to locations" do
  it "routes /locations to locations#index" do
    { :get => "/locations" }.should route_to(
      :controller => "locations",
      :action => "index"
    )
  end
end
