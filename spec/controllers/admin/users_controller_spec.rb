# -*- encoding : utf-8 -*-
#encoding: UTF-8

require 'spec_helper'

describe Admin::UsersController do
  render_views
  it "raises error if non superadmin tries to access users controller" do
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
    before(:each) do 
      @region1 = Fabricate(:region, :name => "Nord")
      @region2 = Fabricate(:region, :name => "Oslofjord")
      @location1 = Fabricate(:location, :name => "Moss redning", :region => @region1)
      @location2 = Fabricate(:location, :name => "Moss rally", :region => @region2)
      
      10.times {Fabricate(:user)}
      2.times {Fabricate(:user, :region => @region1)}
      2.times {Fabricate(:user, :region => @region2)}
      2.times {Fabricate(:user, :location => @location1)}
      2.times {Fabricate(:user, :location => @location2)}
      
      sign_in Fabricate(:user, :super_admin => true)
      
    end

    it "renders all users" do
      @users = User.all
      User.should_receive(:all).and_return(@users)
      get :index
    end
    
    it "renders all users for a region" do
      @users = User.where(:region_id => @region1.id)
      User.should_receive(:where).with(:region_id => @region1.id.to_s).and_return(@users)
      get :index, :region_id => @region1.id
    end
    
    it "can show a user" do
      get :show, :id => Fabricate(:user).id
      response.should render_template "admin/users/show"
    end
    
    it "can edit a user" do
      get :edit, :id => Fabricate(:user).id
      response.should render_template "admin/users/edit"
    end
    
    it "can update a user and redirects to show user" do
      user = Fabricate(:user)
      put :update, :id => user.id, :user => {:email => "some_new_email@rubynor.no"}
      response.should redirect_to admin_user_url(user)
      User.find(user.id).email.should == "some_new_email@rubynor.no"
    end
    
    it "renders edit if the user is invalid" do
      user = Fabricate(:user)
      put :update, :id => user.id, :user => {:email => ""}
      response.should render_template "admin/users/edit"
      response.body.should include("E-post kan ikke være blank")
    end
    
    it "can show the new user form" do
      get :new
      response.should render_template "admin/users/new"
    end
    
    it "can create a user" do
      User.destroy_all
      sign_in Fabricate(:user, :super_admin => true)
      post :create, :user => {:email => "new@rubynor.no", :password => "secret", :password_confirmation => "secret", :super_admin => true}
      User.all.size.should == 2
      response.should redirect_to admin_user_url(User.last.id)
    end
    
    it "can destroy a user" do
      User.destroy_all
      sign_in Fabricate(:user, :super_admin => true)
      user = Fabricate(:user)
      User.all.size.should == 2
      delete :destroy, :id => user.id
      User.all.size.should == 1
      response.should redirect_to admin_users_url
    end
  end
  
end
