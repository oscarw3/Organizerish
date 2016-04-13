class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :checklogin, unless: :dontcheck

  #before_filter :configure_permitted_parameters, if: :devise_controller?

  def checklogin
    if user_signed_in? #&& !current_user.admin?
      if session[:redirectcheck] == true
        sign_out_and_redirect(current_user)
      elsif session[:netidcheck] != true
        session[:redirectcheck] = true
        redirect_to "https://oauth.oit.duke.edu/oauth/authorize.php?client_id=organizerish&redirect_uri=http%3A%2F%2Fcolab-sbx-159.oit.duke.edu%3A3000%2Fnetidsignin&state=b7b486e7002feb52a588853507b403aa0729fbd8f4576105&response_type=token" 
      end
    end
  end

  def dontcheck
    return params[:controller] == "signin"
  end

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
