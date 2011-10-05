class LocationsController < ApplicationController

  def index
    render :json => { :locations => Location.all },  :callback => params[:callback]
  end

end
