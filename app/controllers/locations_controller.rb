class LocationsController < ApplicationController

  respond_to :json

  def index
    render :json => {:success => true, :locations => Location.all}
  end

end
