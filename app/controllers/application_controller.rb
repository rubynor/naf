class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :autneticate_super_admin!
  protected
  def authenticate_super_admin!
    raise "No access" unless current_user && current_user.is_super_admin?
  end
end
