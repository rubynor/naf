# encoding: UTF-8
class ActivitiesController < ApplicationController

  #returns fields used in view
  def fields
    render :json => [
      {:nb => "Navn", :en => "summary", :type => "text_field"},
      {:nb => "Sted", :en => "location_id", :type => "select_box"},
      {:nb => "Kategori", :en => "category_id", :type => "select_box"},
      {:nb => "Beskrivelse", :en => "description", :type => "text_area"},
      {:nb => "Kontaktinformasjon", :en => "contact", :type => "text_area"},
      {:nb => "Link til registrering", :en => "attendee", :type => "text_field"},
      {:nb => "Link til nettside", :en => "url", :type => "text_field"},
      {:nb => "Starter", :en => "dtstart", :type => "datepicker"},
      {:nb => "Avslutter", :en => "dtend", :type => "datepicker"},
      {:nb => "Pris", :en => "price", :type => "text_field"},
      {:nb => "Link til video (Youtube)", :en => "video", :type => "text_field"},
      {:nb => "Deltakerene må huske", :en => "responsibility", :type => "text_area"},
      {:nb => "Kjøretøy", :en => "veichle", :type => "select_box"},
      {:nb => "Deltaker trenger eget kjøretøy", :en => "own_veichle", :type => "check_box"},
      {:nb => "Instruktør på stedet", :en => "supervisor_included", :type => "check_box"},
      {:nb => "Tags", :en => "tags", :type => "text_field"}], :callback => params[:callback]
  end

  def search
    render :json => {:activities => Activity.perform_search(params)}, :callback => params[:callback]
  end

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
