class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_super_admin!

  layout 'admin'

  def index
    @users = User.all
  end
end