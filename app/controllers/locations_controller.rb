# -*- encoding : utf-8 -*-
class LocationsController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        render :json => { :locations => Location.by_name },  :callback => params[:callback]
      end
      format.xml do
        render :xml => {:markers => Location.by_name.map{|location| location.to_marker} },  :callback => params[:callback]
      end
    end
  end

end
