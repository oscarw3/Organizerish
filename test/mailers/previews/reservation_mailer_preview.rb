# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview
	def reservation_started_preview
    	ReservationMailer.reservation_start(Reservation.first)
  	end
  	def reservation_deleted_preview
    	ReservationMailer.resource_deleted(Reservation.first)
  	end
  	
end
