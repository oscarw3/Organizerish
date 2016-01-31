class Reservation < ActiveRecord::Base
  belongs_to :resource

  enum recurring: [:never, :daily, :weekly, :monthly]

  def overlaps?
  	self.resource.reservations.each do |reservation|
  	end
  	false
  end
end
