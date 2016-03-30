class GroupsController < ApplicationController
  

	# Only people with usermanagement access and admin should be able to access all these methods
	def index
		checkaccess
		@groups = Group.where(:hidden => false)

		@user_groups = Group.where(:hidden => true)
	end

	def new
		checkaccess
		@group = Group.new
		
	end

	def create
		checkaccess
		@group = Group.new(group_params)
		@group.hidden = false
  		if @group.save
  			@group.addusers(params["group"]["user_ids"])
  			redirect_to groups_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		checkaccess
		@group = Group.find(params[:id])
	end

	def update
		checkaccess
		@group = Group.find(params[:id])
 
    	if @group.update(group_params)
    		@group.addusers(params["group"]["user_ids"])
    		if @group.hidden
    			redirect_to users_path
    		else
    			redirect_to groups_path
    		end
    	else
    	render 'edit'
    	end
	end

	def destroy
		checkaccess
		@group = Group.find(params[:id])
    	@group.destroy
    	redirect_to groups_path
	end



	private
  	def group_params
    	params.require(:group).permit(:name, :resourcemanagement, :reservationmanagement, :usermanagement)
  	end
end

