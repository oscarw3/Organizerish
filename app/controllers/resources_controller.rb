class ResourcesController < ApplicationController
	include ResourcesHelper
	include SortHelper

	# Admin Index
	# test
	def index
		checkaccess
		# @users are users without admins
		@users = User.where(role: 1)
		refreshtags
		configuretags
	end

	def new
		checkaccess
		@resource = Resource.new
	end

	def create
		checkaccess
		@resource = Resource.new(resource_params)

		if @resource.isrestricted
			puts "is restricted"
		else
			puts "not restricted"
		end


 		@resource.user_id = current_user.id
  		if @resource.save
  			@resource.initialize_permissions
  			@resource.storetags
	  		  params["resource"]["group_ids"].each do |group_id|
	            if group_id != ""
	              @resource.groups << Group.find(group_id)
	            end
	          end
	          @resource.save
  			redirect_to resources_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		checkaccess
		@resource = Resource.find(params[:id])
		@resource.displaytags
		
	end

	def update
		checkaccess
		@resource = Resource.find(params[:id])
 
    	if @resource.update(resource_params)
    		@resource.storetags
    		@resource.clear_groups
			params["resource"]["group_ids"].each do |group_id|
	        	if group_id != ""
	      			@resource.groups << Group.find(group_id)
	       		end
	    	end
	    	@resource.save
    		redirect_to resources_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		checkaccess
		@resource = Resource.find(params[:id])
		@resource.delete_reservations
		@resource.delete_permissions
    	@resource.destroy
    	refreshtags
    	redirect_to resources_path
	end

	def removetag
		checkaccess
		tag = Tag.find(params[:tag])
		resource = Resource.find(params[:resource])
		resource.tags.delete(tag)
		refreshtags
		redirect_to resources_path
	end

	# update list of tags
	def refreshtags
		if Tag.all != nil
			@badtags = Tag.all.select {
				|tag|
				@usedresources = Resource.all.select {
	        	|resource|
	        	resource.tags.include? tag
	      		}
	      		@usedresources.empty?
			}
			@badtags.each {
				|tag|
				tag.destroy
			}
		end
	end

	def permissions
		checkaccess
		@resource = Resource.find(params[:id])
		@permissions = @resource.permissions.where(viewaccess: 1).where(reserveaccess: 0) + @resource.permissions.where(viewaccess: 0).where(reserveaccess: 1)
	end

	def updatepermissions
		@resource = Resource.find(params[:id])
		@resource.add_to_permissions(params["groups"]["id"])
		redirect_to resources_path
	end


	private
  	def resource_params
    	params.require(:resource).permit(:name, :description, :temp_tags, :group_ids, :isrestricted)
  	end
end
