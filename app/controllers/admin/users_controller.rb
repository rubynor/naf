class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_super_admin!

  layout 'admin'

  def index
    if params[:region_id]
      @users = User.where(:region_id => params[:region_id])
    else
      @users = User.all
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_user_url(@user), :notice => "Bruker opprettet"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_user_url(@user), :notice => "Bruker endret"
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url
  end

end