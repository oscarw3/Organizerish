class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:user) { |u| u.permit(:access_token) }
  end

  def authorize_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end

  def checkaccess
    if no_resources? || no_reservations? || no_users?
      nopermission
    end
  end


  def no_resources?
    if params[:controller] == "resources" && !current_user.has_resource_management?
      return true
    else
      return false
    end
  end

  def no_reservations?
    if params[:controller] == "reservations" && !current_user.has_reservation_management?
      return true
    else
      return false
    end
  end

  def no_users?
    if (params[:controller] == "users" || params[:controller] == "groups") && !current_user.has_user_management?
      return true
    else
      return false
    end
  end


  def nopermission
    redirect_to reservations_path, notice: "You don't have management access to the page!"
  end
end
