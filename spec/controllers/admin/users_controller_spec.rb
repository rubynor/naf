require 'spec_helper'

describe Admin::UsersController do
  
  it "raises error if no superadmin tries to access users controller" do
    sign_in Fabricate(:user, :super_admin => false)
    expect {get :index}.to raise_exception "No access"
  end
  
  it "renders OK if user is superadmin" do
    sign_in Fabricate(:user, :super_admin => true)
    get :index
    response.should render_template "admin/users/index"
    response.should render_template "layouts/admin"
  end
  
  context "super admin" do
    before(:each){sign_in Fabricate(:user, :super_admin => true)}
    it "renders all users" do
      get :index, 
    end
  end
  
end