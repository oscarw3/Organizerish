class UsersController < ApplicationController
  before_filter :authorize_admin, only: :create
  
  def new
		checkadmin 
		@user = User.new
	end

	def create
		checkadmin
		@user = User.new(user_params)
 		@user.user_id = current_user.id
  		if @user.save
  			redirect_to users_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		# checkadmin
		# @user = User.find(params[:id])
	end

	def update
		# checkadmin
		# @user = User.find(params[:id])
 
  #   	if @user.update(user_params)
  #   		redirect_to users_path
  #   	else
  #   	render 'edit'
  #   	end
	end

	def destroy
		checkadmin
		@user = User.find(params[:id])
    	@user.destroy
 
    	redirect_to users_path
	end



	private
  	def user_params
    	params.require(:user).permit(:firstname, :lastname, :email, :password)
  	end
end
