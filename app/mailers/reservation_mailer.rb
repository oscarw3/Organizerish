class ReservationMailer < ApplicationMailer
	default from: "organizerish@gmail.com"

	def reservation_start(reservation)
    	@reservation = reservation
    	@user = User.find(@reservation.occupied)
    	mail(to: @user.email, subject: 'Your reservation has started!')
  	end

  	def resource_deleted(reservation)
  	 	@reservation = reservation
  	 	@user = User.find(@reservation.occupied)
  	 	mail(to: @user.email, subject: 'The resource was deleted :(')

  	end

    def reservation_unapproved(reservation)
      @reservation = reservation
      @user = User.find(@reservation.occupied)
      mail(to: @user.email, subject: 'Your reservation was not approved')
    end


end
