class UsersController < ApplicationController

  before_filter :authorize_admin, only: :create

  	def new
		checkaccess
		@user = User.new
	end

	def index
		checkaccess
		@users = User.where(role: 1)
		@user_groups = Group.where(:hidden => true)
	end

	def create
		checkaccess
		@user = User.new(user_params)
  		if @user.save
  			makegroup(@user)
  			redirect_to users_path
  		else
  			render 'new'
  		end
	end

	def show
	end

	def edit
		checkaccess
		@user = User.find(params[:id])
	end

	def makegroup(user)
  		@group = Group.create(name: user.email, resourcemanagement: 0, reservationmanagement: 0, usermanagement: 0, hidden: true)
  		@group.users << user
  		@group.save
  		user.save
	end

	def destroygroup(email)
 		Group.where(:name => email).each do |usergroup|
 			if usergroup.hidden
 				usergroup.destroy
 			end
 		end
	end

	def update
		checkaccess
		@user = User.find(params[:id])
    	if @user.update(user_params)
    		makegroup(@user)
    		redirect_to users_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		checkaccess
		@user = User.find(params[:id])
    	@user.destroy
 		Reservation.where(:occupied => @user.id).each do |reservation|
 			reservation.destroy
 		end
 		destroygroup(@user.email)
    	redirect_to users_path
	end



	private
  	def user_params
    	params.require(:user).permit(:firstname, :lastname, :email, :password)
  	end
end
