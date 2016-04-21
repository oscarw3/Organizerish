class Node < ActiveRecord::Base
	has_many :resources

  def clear_children
    self.resources.each do |resource|
      self.resources.delete(resource)
    end
  end

  def add_to_reservation(reservation)
    reservation.resources.each do |resource|
      puts resource.name
    end
  	self.resources.each do |resource|
  		if !reservation.resources.include?(resource)
  			reservation.resources << resource
            if Node.where(:parent_id => resource.id).count == 1
              Node.where(:parent_id => resource.id).first.add_to_reservation(reservation)
            end
  		end
  	end
  end

end
