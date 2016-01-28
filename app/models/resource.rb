class Resource < ActiveRecord::Base
  belongs_to :user

  enum role: [:never, :daily, :weekly, :monthly]
end
