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
  end

  def destroy
  end
end
