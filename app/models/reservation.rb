class Reservation < ActiveRecord::Base
  belongs_to :resource

  enum recurring: [:never, :daily, :weekly, :monthly]

  def overlaps?
  	self.resource.reservations.each do |reservation|
  		if (reservation.starttime < self.endtime && reservation.endtime > self.starttime) 
  			return true
  		end
  		
  	end
  	false
  end
  
end
