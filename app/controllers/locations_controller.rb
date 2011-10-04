class LocationsController < ApplicationController

  respond_to :json

  def index
    render :json => {:locations => Location.all}
  end

end
