class LocationsController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        render :json => { :locations => Location.all },  :callback => params[:callback]
      end
      format.xml do
        render :xml => {:markers => Location.all.map{|location| location.to_marker} },  :callback => params[:callback]
      end
    end
  end

end
