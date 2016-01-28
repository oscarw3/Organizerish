class ReservationsController < ApplicationController
  
  def index
  	@resources = Resource.all
  end

  def new
  	@reservation = Reservation.new
  	@resource = Resource.find(params[:resource])
  end

  def create

		@reservation = Reservation.new(reservation_params)
  		if @reservation.save
  			redirect_to reservations_path
  		else
  			render 'new'
  		end
	end

	def show 
	end

	def edit
		@reservation = Reservation.find(params[:id])
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
		@reservation = reservation.find(params[:id])
    	@reservation.destroy
 
    	redirect_to reservations_path
	end

	private
  	def reservation_params
    	params.require(:reservation).permit(:starttime, :endtime, :recurring, :resource_id)
  	end
end
