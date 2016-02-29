class Api::ResourcesController < ApiController
	respond_to :json
	def index
		@resources = Resource.all
		respond_with @resources
	end

	def create
		@resource = Resource.new(resource_params)
 		@resource.user_id = current_user.id
 		@resource.save
  		@resource.initialize_permissions
 		respond_with @resource

	end

	def update 
		@resource = Resource.find(params[:id])
		if @resource.update(resource_params)
			respond_with @resource
		end
	end

	def destroy
		@resource = Resource.find(params[:id])
		@resource.delete_reservations
		@resource.delete_permissions
		@resource.destroy
		respond_with @resource
	end

	private
  	def resource_params
    	params.require(:resource).permit(:name, :description)
  	end
end
