# encoding: UTF-8
class ActivitiesController < ApplicationController

  def file_upload
    begin
    photo = Photo.create(:photo => params[:photo])
    render :text => {:file => photo, :success => true}.to_json, :layout => false
    rescue => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      render :text => {:success => false}.to_json, :layout => false
    end

  end

  def search
    @activities, @total = Activity.perform_search(params)
    render :json => {:activities => @activities, :total => @total }, :callback => params[:callback]
  end

  def show
    render :json => Activity.find(params[:id]), :callback => params[:callback]
  end

  def index
    @activities = Activity.by_start_date.page(params[:page]).per(params[:limit])
    render :json => { :activities => @activities, :total => @activities.total_count }, :callback => params[:callback]
  end

  def create
    begin
    @activity = Activity.new(params[:activity])
    if @activity.save
      render :json => @activity, :callback => params[:callback], :status => :ok
    else
      render :json => @activity.errors, :callback => params[:callback], status => :unprocessable_entity
    end
    rescue => e
      ap e
      render :json => {:error => e.inspect}.to_json
    end
  end

  def update
    begin
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      render :json => @activity, :callback => params[:callback], :status => :ok
    else
      render :json => @activity.errors, :status => :unprocessable_entity
    end
    rescue => e
      ap e
      render :json => {:error => e.inspect}.to_json
    end
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.destroy
    render :json => "true", :callback => params[:callback]
  end
end
