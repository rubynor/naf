# encoding: UTF-8
class ActivitiesController < ApplicationController

  # returns fields used in view
  # this will be refactored into its own logic when all the fields are set
  #
  def fields
    render :json => Activity.fields_schema, :callback => params[:callback]
  end

  def search
    @activities, @total = Activity.perform_search(params)
    render :json => {:activities => @activities, :total => @total }, :callback => params[:callback]
  end

  def show
    render :json => Activity.find(params[:id]), :callback => params[:callback]
  end

  def index
    @activities = Activity.page(params[:page]).per(params[:limit])
    render :json => { :activities => @activities, :total => @activities.total_count }, :callback => params[:callback]
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
