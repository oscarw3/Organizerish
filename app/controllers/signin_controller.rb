class SigninController < ApplicationController
	def duke
		puts "PARAMS START HERE"
  		puts params.inspect
  		puts request.inspect
  		redirect_to reservations_path
  	end
  	def allowaccess?
  		return true
  	end
end