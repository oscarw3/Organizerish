class Api::GroupsController < ApiController
	respond_to :json
	def index	
		@groups = Group.all
		respond_with @groups
	end

	def create
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@group = Group.new(group_params)
			@group.hidden = false
	 		if @group.save
				@group.addusers(params["group"]["user_ids"])
	 		respond_with @group
	 	end

	end

	def update 
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@group = Group.find(params[:id])
			if @group.update(group_params)
				@group.addusers(params["group"]["user_ids"])
				respond_with @group
			end
		end
	end

	def destroy
		if !current_user.has_user_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@group = Group.find(params[:id])
			@group.destroy
			respond_with @group
		end
	end

	private
  	def group_params
    	params.require(:group).permit(:name, :resourcemanagement, :reservationmanagement, :usermanagement)
  	end
end
