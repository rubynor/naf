class CategoriesController < ApplicationController

  def index
    render :json => {:categories => Category.all}, :callback => params[:callback]
  end

end
