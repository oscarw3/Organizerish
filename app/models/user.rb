class User < ActiveRecord::Base
	acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_and_belongs_to_many :groups
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  # used to distinguish if user is admin or not
  enum role: [:admin, :basic]

  after_update :log_changed

  def log_changed
  	Group.where(:name => changed_attributes["email"]).each do |usergroup|
  		if usergroup.hidden
  			usergroup.destroy
  		end
  	end
  end

  def admin?
  	if self.role == "admin"
  		return true
  	else
  		return false
  	end
  end

  def has_resource_management?
  	if self.admin?
  		return true
  	end
  	self.groups.each do |group|
  		if group.resourcemanagement == 1
  			return true
  		end
  	end
  	return false
  end

  def is_restricted_resource_manager(reservation)
  	reservation.unapproved_resources.each do |resource|
     resource.groups.each do |group|
      group.users.each do |user|
       if self.id == user.id
        return true
      end
    end
  end
end
return false
end

def has_reservation_management?
 if self.admin?
  return true
end
self.groups.each do |group|
  if group.reservationmanagement == 1
   return true
 end
end
return false
end

def has_user_management?
 if self.admin?
  return true
end
self.groups.each do |group|
  if group.usermanagement == 1
   return true
 end
end
return false
end

def create_reservation_permission?(resource)
 if self.has_reservation_management?
  return true
end
groups = resource.permissions.where(reserveaccess: 1).first.groups
if !groups.includes(:users).where(users: { id: self.id}).empty?
  return true
end
return false
end

def edit_reservation_permission?(reservation)
 if self.has_reservation_management? || reservation.occupied == self.id
  return true
else
  return false
end
end

def view_reservation?(reservation)
  if self.has_resource_management? || self.has_reservation_management?
    return true
  end
  reservation.resources.each do |resource|
    if self.view_permission?(resource)
      return true
    end
  end
  return false
end

def view_permission?(resource)
 if self.has_resource_management? || self.has_reservation_management?
  return true
end
groups = resource.permissions.where(viewaccess: 1).first.groups
if !groups.includes(:users).where(users: { id: self.id}).empty?
  return true
end
return false
end

def addgroup(group)
 self.groups << group
 self.save
end

end
