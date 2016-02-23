class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_and_belongs_to_many :groups
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # used to distinguish if user is admin or not
  enum role: [:admin, :basic]

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

end
