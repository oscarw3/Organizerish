class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # used to distinguish if user is admin or not
  enum role: [:admin, :basic]

	def checkadmin
	# if not admin, redirect to different page
		if self.role != "admin"
			#TODO: redirect and add alert if not admin
		end
	end
end
