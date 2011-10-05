class ActivitiesController < ApplicationController



  def show
    render :json => Activity.find(params[:id]), :callback => params[:callback]
  end

  def index
    render :json => { :activities => Activity.all }, :callback => params[:callback]
  end

  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      render :json => @activity, :callback => params[:callback], :status => :ok
    else
      render :json => @activity.errors, :callback => params[:callback], status => :unprocessable_entity
    end
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      render :json => @activity, :callback => params[:callback], :status => :ok
    else
      render :json => @activity.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.destroy
    render :json => "true", :callback => params[:callback]
  end
end
