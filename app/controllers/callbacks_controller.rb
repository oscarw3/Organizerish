class CallbacksController < Devise::OmniauthCallbacksController
  before_action :configure_permitted_parameters

  def configure_permitted_parameters
    # Permit the `subscribe_newsletter` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_in, keys: [:access_token])
  end

  def duke
  	auth = request.env['omniauth.auth']
  	render json: auth.to_json
  	puts "PARAMS START HERE"
  	puts params
    #@user = User.from_omniauth(request.env["omniauth.auth"])
    #sign_in_and_redirect @user
  end
  def failure
  	if failure_message=="Csrf detected"
  		duke
  	else
  		super
  	end
  end
end