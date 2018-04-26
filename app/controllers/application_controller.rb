class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions

  before_action :authenticate_user!
end
