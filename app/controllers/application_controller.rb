class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_controller

  before_filter :authenticate_user!

  protected

  def layout_by_controller
    devise_controller? ? 'devise' : 'application'
  end

end


