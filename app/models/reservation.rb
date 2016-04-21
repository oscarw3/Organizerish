class Reservation < ActiveRecord::Base
  has_and_belongs_to_many :resources
  has_and_belongs_to_many :unapproved_resources, :class_name => 'Resource', :join_table => :reservations_unapproved_resources

  enum recurring: [:never, :daily, :weekly, :monthly]

  validates :title, presence: true, allow_blank: false

  def overlaps?
  	self.resources.each do |resource|
      resource.reservations.each do |reservation|
        if reservation.isapproved?
    		  if (reservation.starttime < self.endtime && reservation.endtime > self.starttime) 
    			 return true
    		  end
        end
      end
  	end
  	false
  end

  def record_unapproved_resources
    self.resources.each do |resource|
      if resource.isrestricted?
        self.unapproved_resources << resource
      end
    end
  end

  def not_approved_overlaps
    reservations = []

    self.resources.each do |resource|
      resource.reservations.each do |reservation|
        if !reservation.isapproved?
          if (reservation.starttime < self.endtime && reservation.endtime > self.starttime) && (!reservations.include?(reservation)) && (reservation != self)
           reservations << reservation
          end
        end
      end
    end

    return reservations
  end

  def invalid?
    return self.starttime > self.endtime
  end

    #IDs << reservation.id


  def clear_resources
    self.resources.each do |resource|
      self.resources.delete(resource)
    end
  end
  
end
