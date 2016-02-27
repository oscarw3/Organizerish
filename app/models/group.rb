class Group < ActiveRecord::Base
	has_and_belongs_to_many :permissions
	has_and_belongs_to_many :users

	def addusers(usersarray)
		self.users.each do |user|
			self.users.delete(user)
		end
		
		usersarray.each do |userid|
			if userid != ''
				user = User.find(userid)
				self.users << user
			end
		end
		self.save
	end
end
