class Admin::LocationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_super_admin!

  layout 'admin'

  def index
    @locations = Location.all
  end

  def edit
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def show
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.new(params[:location])

    if @location.save
      redirect_to admin_location_url(@location), :notice => "Lokasjon opprettet"
    else
      render "new"
    end
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to admin_location_url(@location), :notice => "Lokasjon endret"
    else
      render "edit"
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to admin_locations_url, :notice => "Lokasjon slettet"
  end

end