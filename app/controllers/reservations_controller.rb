class ReservationsController < ApplicationController
  
  def index
  	@reservations = Reservation.where(occupied: current_user.id)
  	@resources = Resource.all

  end

  def new
  	@reservation = Reservation.new
  	@resource = Resource.find(params[:resource])
  end

  def create

		@reservation = Reservation.new(reservation_params)
		@reservation.occupied = current_user.id
      if @reservation.overlaps?
        # do something here
        
  		elsif @reservation.save
  			redirect_to reservations_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		@reservation = Reservation.find(params[:id])
		@resource = @reservation.resource
	end

	def update
		@reservation = Reservation.find(params[:id])
 
    	if @reservation.update(reservation_params)
    		redirect_to reservations_path
    	else
    	render 'edit'
    	end
	end

	def destroy
		@reservation = Reservation.find(params[:id])
    	@reservation.destroy
 
    	redirect_to reservations_path
	end

	private
  	def reservation_params
    	params.require(:reservation).permit(:starttime, :endtime, :recurring, :resource_id)
  	end
end
