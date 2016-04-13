class Node < ActiveRecord::Base
	has_many :resources

  def clear_children
    self.resources.each do |resource|
      self.resources.delete(resource)
    end
  end
end
