
require 'spec_helper'

describe Admin::ActivitiesController do
  
  it "redirects if there is no user" do
    get :index
    response.should redirect_to "/user/sign_in"
  end
  
  it "grant access when user is logged in" do
    sign_in Fabricate(:user)
    get :index
    response.should render_template "admin/activities/index"
    response.should render_template "layouts/activities"
  end
  
end
