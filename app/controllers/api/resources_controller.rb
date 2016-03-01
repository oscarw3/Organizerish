class Api::ResourcesController < ApiController
	respond_to :json
	def index	
		@resources = Resource.all
		respond_with @resources
	end

	def create
		if !current_user.has_resource_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@resource = Resource.new(resource_params)
	 		@resource.user_id = current_user.id
	 		@resource.save
	  		@resource.initialize_permissions
	  		#if no tags added, don't add tags
	  		if params["tags"] != nil
	  			@resource.addtags(params["tags"])
	  		end
	 		respond_with @resource
	 	end

	end

	def update 
		if !current_user.has_resource_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@resource = Resource.find(params[:id])
			if @resource.update(resource_params)

				respond_with @resource
			end
		end
	end

	def destroy
		if !current_user.has_resource_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@resource = Resource.find(params[:id])
			@resource.delete_reservations
			@resource.delete_permissions
			@resource.destroy
			respond_with @resource
		end
	end

	private
  	def resource_params
    	params.require(:resource).permit(:name, :description)
  	end
end
