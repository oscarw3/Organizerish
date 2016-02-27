class Permission < ActiveRecord::Base
  belongs_to :resource
  has_and_belongs_to_many :groups

  def access
  	if self.viewaccess == 1 && self.reserveaccess == 0
  		"View Access"
	elsif self.viewaccess == 0 && self.reserveaccess == 1
  		"Reserve Access"
  	else
  		"Other thing"
  	end
  end

  def remove_groups
  	self.groups.each do |group|
			self.groups.delete(group)
	end
  end
end
