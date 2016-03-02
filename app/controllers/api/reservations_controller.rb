class Api::ReservationsController < ApiController
	respond_to :json
	def index	
		@reservations = Reservation.all
		respond_with @reservations
	end

	def create
		if !current_user.has_reservation_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@reservation = Reservation.new(reservation_params)
			@reservation.occupied = current_user.id
			if !@reservation.overlaps?
				if @reservation.save
					ReservationMailer.delay(:run_at => @reservation.starttime).reservation_start(@reservation)
			else
				render json: { error: 'Overlapping Reservation'}, status: 401
	 		respond_with @reservation
	 	end

	end

	def update 
		if !current_user.has_reservation_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@reservation = Reservation.find(params[:id])
			if @reservation.update(reservation_params)
				respond_with @reservation
			end
		end
	end

	def destroy
		if !current_user.has_reservation_management?
			render json: { error: 'Access Denied'}, status: 401
		else
			@reservation = Reservation.find(params[:id])
			@reservation.destroy
			respond_with @reservation
		end
	end

	private
  	def reservation_params
    	params.require(:reservation).permit(:resource, :starttime, :endtime, :recurring)
  	end
end