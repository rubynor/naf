class Admin::ActivitiesController < ApplicationController
  before_filter :authenticate_user!

  layout 'activities'

  def index
  end

end