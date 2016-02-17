class GroupsController < ApplicationController
  

	# Only people with usermanagement access and admin should be able to access all these methods
	def index
		@groups = Group.all
	end

	def new
		
		@group = Group.new
		
	end

	def create
		
		@group = Group.new(group_params)
  		if @group.save
  			redirect_to groups_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		
		@group = Group.find(params[:id])
	end

	def update
		
		@group = Group.find(params[:id])
 
    	if @group.update(group_params)
    		redirect_to groups_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		
		@group = Group.find(params[:id])
    	@group.destroy
    	redirect_to groups_path
	end



	private
  	def group_params
    	params.require(:group).permit(:name, :resourcemanagement, :reservationmanagement, :usermanagement)
  	end
end

