require 'spec_helper'

describe CategoriesController do
  
  before(:each) do
    @request.env["HTTP_ACCEPT"] = "application/json"
  end
  
  it "should find all categories" do
    category1 = Category.create(:name => "Cat1")
    category2 = Category.create(:name => "Cat2")
    get :index
    ActiveSupport::JSON.decode(response.body) == ActiveSupport::JSON.decode([category1, category2].to_json)
  end

end
