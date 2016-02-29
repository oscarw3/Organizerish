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
  
  	@resources, @tags_selected = getresources(@tagstring)

    @tags_left = removeselectedtags(@tags_selected)

    


  end

  def new
    
  	 @reservation = Reservation.new
  	 @resource = Resource.find(params[:resource])
    if !current_user.create_reservation_permission?(@resource)
      redirect_to reservations_path, notice: "You don't have reservation access to the page!"
    end

  end

  def create

		@reservation = Reservation.new(reservation_params)
    if !current_user.create_reservation_permission?(@reservation.resource)
      redirect_to reservations_path, notice: "You don't have reservation access to the page!"
    end
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
    if !current_user.edit_reservation_permission?(@reservation)
     redirect_to reservations_path, notice: "This isn't your reservation!"
    end
		@resource = @reservation.resource
	end

	def update
		@reservation = Reservation.find(params[:id])
    if !current_user.edit_reservation_permission?(@reservation)
     redirect_to reservations_path, notice: "This isn't your reservation!"
    end
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
    if !current_user.edit_reservation_permission?(@reservation)
     redirect_to reservations_path, notice: "This isn't your reservation!"
    end
    	@reservation.destroy
 
    	redirect_to reservations_path
	end

	private
  	def reservation_params
    	params.require(:reservation).permit(:starttime, :endtime, :recurring, :resource_id)
  	end
end
