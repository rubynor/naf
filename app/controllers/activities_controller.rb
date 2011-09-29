class ActivitiesController < ApplicationController

  respond_to :json

  def show

  end

  def index
  end

  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      respond_with @activity, :status => :ok
    else
      respond_with @activity.errors, status => :unprocessable_entity
    end
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      respond_with @activity, :status => :ok
    else
      respond_with @activity.errors, status => :unprocessable_entity
    end
  end

  def destroy
  end
end
