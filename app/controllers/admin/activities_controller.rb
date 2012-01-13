# -*- encoding : utf-8 -*-
class Admin::ActivitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:search, :file_upload]
  skip_before_filter :verify_authenticity_token, :only => [:file_upload]

  layout 'admin'

  def file_upload
    photo = Photo.create(:photo => params[:photo])
    render :json => {:photo => photo}.to_json
  end



  def new
    @activity = Activity.new
    build_embedded
  end

  def edit
    @activity = Activity.find(params[:id])
    build_embedded
  end

  def copy
    @activity = Activity.find(params[:id]).dup
    render "new"
  end

  def search
    @activities, @total = Activity.perform_search(params)
    respond_to do |format|
      format.html{render "index"}
      format.json{render :json => {:activities => @activities, :total => @total }, :callback => params[:callback]}
    end
  end

  def show
    @activity = Activity.find(params[:id])
    respond_to do |format|
      format.html {}
      format.json{
        render :json => @activity, :callback => params[:callback]
      }
    end
  end

  def index
    @activities = Activity.by_start_date.page(params[:page]).per(params[:limit])
    respond_to do |format|
      format.html {}
      format.json do
        render :json => { :activities => @activities, :total => @activities.total_count }, :callback => params[:callback]
      end
    end
  end

  def create
    @activity = Activity.new(params[:activity].merge({:user => current_user}))
    if @activity.save
      redirect_to admin_activity_url(@activity), :notice => "Aktivitet opprettet"
    else
      render "new"
    end

  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      respond_to do |format|
        format.html{redirect_to admin_activity_url(@activity), :notice => "Aktiviteten ble oppdatert"}
        format.json{render :json => @activity, :callback => params[:callback], :status => :ok}
      end
    else
      respond_to do |format|
        format.html{render "edit"}
        format.json{render :json => @activity.errors, :status => :unprocessable_entity}
      end
    end

  end

  def destroy
    activity = Activity.find(params[:id])
    activity.destroy
    respond_to do |format|
      format.html{redirect_to admin_activities_url, :notice => "Aktiviteten ble slettet"}
      format.json{render :json => "true", :callback => params[:callback]}
    end
  end

  private

  def build_embedded
    @activity.internal_information = InternalInformation.new unless @activity.internal_information
    @activity.political_activity = PoliticalActivity.new unless @activity.political_activity
  end
end
