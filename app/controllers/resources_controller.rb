class ResourcesController < ApplicationController


	# Admin Index
	def index
		checkadmin
		# @users are users without admins
		@users = User.where(role: 1)
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
  			@resource.storetags
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
		@resource.displaytags
	end

	def update
		checkadmin
		@resource = Resource.find(params[:id])
 
    	if @resource.update(resource_params)
    		@resource.storetags
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




	private
  	def resource_params
    	params.require(:resource).permit(:name, :description, :temp_tags)
  	end
end
