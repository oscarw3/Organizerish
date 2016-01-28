class ResourcesController < ApplicationController
	def index
		checkadmin
		@resources = Resource.all
	end
	def new
		checkadmin 
		@resource = Resource.new
	end

	def create
		checkadmin
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
		checkadmin
		@resource = Resource.find(params[:id])
	end

	def update
		checkadmin
		@resource = Resource.find(params[:id])
 
    	if @resource.update(resource_params)
    		redirect_to resources_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		checkadmin
		@resource = Resource.find(params[:id])
    	@resource.destroy
 
    	redirect_to resources_path
	end


	def checkadmin
		if !current_user.admin?
			redirect_to reservations_path
		end
	end

	private
  	def resource_params
    	params.require(:resource).permit(:name, :description)
  	end
end
