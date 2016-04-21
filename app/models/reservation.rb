class Reservation < ActiveRecord::Base
  has_and_belongs_to_many :resources
  has_and_belongs_to_many :unapproved_resources, :class_name => 'Resource', :join_table => :reservations_unapproved_resources

  enum recurring: [:never, :daily, :weekly, :monthly]

  validates :title, presence: true, allow_blank: false

  before_update :check_range

  def simultaneous(resource)
    simultaneousreservations = 1
    resource.reservations.each do |reservation|
      if reservation.isapproved?
        if (reservation.starttime < self.endtime && reservation.endtime > self.starttime) 
          simultaneousreservations = simultaneousreservations + 1
        end
      end
    end
    return simultaneousreservations
  end

  def overlaps?
   self.resources.each do |resource|
    sim = simultaneous(resource)
    if ((resource.sharing_level == 0) && (sim > 1)) || ((resource.sharing_level == 1) && (sim > resource.sharing_limit))
      return true
    end
  end
  return false
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
          if (resource.sharing_level == 0) || ((resource.sharing_level == 1) && (self.simultaneous(resource) == resource.sharing_limit))
            reservations << reservation
          end
        end
      end
    end
  end

  return reservations
end

def invalid?
  return self.starttime >= self.endtime
end


def clear_resources
  self.resources.each do |resource|
    self.resources.delete(resource)
  end
end

private

def check_range
  if starttime < starttime_was
    starttime = starttime_was
    errors.add(:starttime, "You can not extend the time of your reservation.")
    return false
  end
  if endtime > endtime_was
    endtime = endtime_was
    errors.add(:endtime, "You can not extend the time of your reservation.")
    return false
  end
  return true
end
end
