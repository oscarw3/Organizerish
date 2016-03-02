class Api::UsersController < ApiController
	respond_to :json
	def index	
		@users = User.all
		respond_with @users
	end

	def create
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@user = User.new(user_params)
	 		@user.save
	 		respond_with @user
	 	end

	end

	def update 
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@user = User.find(params[:id])
			if @user.update(user_params)
				respond_with @user
			end
		end
	end

	def destroy
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@user = User.find(params[:id])
			@user.destroy
			Reservation.where(:occupied => @user.id).each do |reservation|
				reservation.destroy
			end
			respond_with @user
		end
	end

	private
  	def user_params
    	params.require(:user).permit(:firstname, :lastname, :email, :password)
  	end
end