class LocationsController < ApplicationController

  respond_to :json

  def index
    respond_with :json => {:success => true, :locations => Location.all}
  end

end
