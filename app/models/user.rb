class User < ActiveRecord::Base
  belongs_to :group
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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
end
