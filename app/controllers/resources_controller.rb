class ResourcesController < ApplicationController
	def index
		current_user.checkadmin
		@resources = Resource.all
	end
	def new 
		@resource = Resource.new
	end

	def create
		@resource = Resource.new(resource_params)
 		@resource.user_id = current_user.id
  		if @resource.save
  			redirect_to resources_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		@resource = Resource.find(params[:id])
	end

	def update
		@resource = Resource.find(params[:id])
 
    	if @resource.update(resource_params)
    		redirect_to resources_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		@resource = Resource.find(params[:id])
    	@resource.destroy
 
    	redirect_to resources_path
	end

	private
  	def resource_params
    	params.require(:resource).permit(:name, :description)
  	end
end
