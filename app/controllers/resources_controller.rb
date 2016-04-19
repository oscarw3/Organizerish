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
		
 		@resource.user_id = current_user.id
  		if @resource.save
  			@resource.initialize_permissions
  			@resource.storetags
	  		  params["resource"]["group_ids"].each do |group_id|
	            if group_id != ""
	              restricted_managers_group = Group.find(group_id)
	              @resource.groups << restricted_managers_group
	              # add restricted managers to resource
	              restricted_managers_group.permissions << @resource.permissions.where(viewaccess: 1).where(reserveaccess: 0) 
	              restricted_managers_group.permissions << @resource.permissions.where(viewaccess: 0).where(reserveaccess: 1)
	              restricted_managers_group.save
	            end
	          end
	          #adding children to parent node
	          childrenarray = params["resource"]["id"]
	          childrenarray.pop

	          if childrenarray.count > 0
	          	node = Node.create(:parent_id => @resource.id)
	          	node.save
	          	childrenarray.each do |child_id|
	          		child = Resource.find(child_id)
	          		child.node = node
	          		if child.cycle?(Resource.find(node.parent_id))
	          			node.clear_children
	          			node.destroy
	          			redirect_to resources_path, notice: "There's a cycle!"
	          			return
	          		else
	          			child.save
	          		end

	          	end
	          	node.save
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
		alreadyredirected = false
	    
    	if @resource.update(resource_params)
    		@resource.storetags
    		@resource.clear_groups
			params["resource"]["group_ids"].each do |group_id|
	        	if group_id != ""
	      			@resource.groups << Group.find(group_id)
	       		end
	    	end
	    	if Node.where(:parent_id => @resource.id).count == 0
	    		node = Node.create(:parent_id => @resource.id)
	    	else
	    		node = Node.where(:parent_id => @resource.id).first
	    	end

	    	@oldresources = []
	    	node.resources.each do |resource|
	    		@oldresources << resource
	    	end
	    	

	    	childrenarray = params["resource"]["id"]
	        childrenarray.pop

	    	if childrenarray.count == 0
	    		node.clear_children
	    		
	    		node.destroy
	    	else

	    		node.clear_children
	          	childrenarray.each do |child_id|
	          		child = Resource.find(child_id)
	          		child.node = node
	          		if child.cycle?(Resource.find(node.parent_id))
	          			node.clear_children
	          			
	          			if @oldresources.count == 0
	          				node.destroy
	          			else

	          				@oldresources.each do |resource|
	          					node.resources << resource
	          				end
	          				node.save
	          				@resource.save
	          			end

	          			redirect_to resources_path, notice: "There's a cycle!"
	          			alreadyredirected = true
	          		else
	          			child.save
	          		end

	          	end
	          	node.save
	         end
	    	@resource.save
	    	if !alreadyredirected
    			redirect_to resources_path
    		end
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

	def addtag
		checkaccess
		tag = Tag.find(params[:tag])
		resource = Resource.find(params[:resource])
		resource.addtag(tag)
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
    	params.require(:resource).permit(:name, :description, :temp_tags, :group_ids, :isrestricted, :sharing_level, :sharing_limit)
  	end
end
