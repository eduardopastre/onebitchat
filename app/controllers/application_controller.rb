class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
    end
  end
  
end
