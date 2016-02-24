class Permission < ActiveRecord::Base
  belongs_to :resource
  belongs_to :group

  def access
  	if self.viewaccess == 0 && self.reserveaccess == 0
  		"No Access"
  	elsif self.viewaccess == 1 && self.reserveaccess == 0
  		"View Access"
	elsif self.viewaccess == 0 && self.reserveaccess == 1
  		"Reserve Access"
  	else
  		"Both Access"
  	end
  end
end
