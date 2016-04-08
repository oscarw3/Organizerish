class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :allowaccess?
  before_action :checknetID, 

  #before_action :configure_permitted_parameters, if: :devise_controller?



  def allowaccess?
    return false
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

  protected

  def configure_permitted_parameters
    registration_params = [:email, :usernamename, :password, :password_confirmation]
    devise_parameter_sanitizer.for(:sign_in) << :access_token
  end
end
