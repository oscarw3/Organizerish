class SigninController < ApplicationController
	def checknetid
		session[:netidcheck] = true
    session[:redirectcheck] = false
  		if params[:error] == "access_denied"
  			flash[:notice] = params[:error_description]
  			sign_out_and_redirect(current_user)
  			return
  		else
  			redirect_to root_path, alert: "NetID verified"
  		end
  	end
end