class ReservationsController < ApplicationController
  include ReservationsHelper

  def index
    @allreservations = Reservation.all 
    @myreservations = Reservation.where(occupied: current_user.id)
    
    if params[:tag] != nil && params[:tags] != nil
      @tagstring = params[:tags] + '%' + params[:tag]
    elsif params[:tag] != nil && params[:tags] == nil
      @tagstring = params[:tag]
    else
      @tagstring = ''
    end
  
  	@resources = getresources(@tagstring)
    @tags = Tag.all


  end

  def new
  	@reservation = Reservation.new
  	@resource = Resource.find(params[:resource])
  end

  def create

		@reservation = Reservation.new(reservation_params)
		@reservation.occupied = current_user.id
      if @reservation.overlaps?
        flash[:notice] = "This reservation overlaps!"
        redirect_to reservations_path
  		elsif @reservation.save
        ReservationMailer.delay(:run_at => @reservation.starttime).reservation_start(@reservation) 
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
      if @reservation.overlaps?
        flash[:notice] = "This reservation overlaps!"
        redirect_to reservations_path
    	elsif @reservation.update(reservation_params)
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
