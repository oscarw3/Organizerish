class Reservation < ActiveRecord::Base
  belongs_to :resource

  enum recurring: [:never, :daily, :weekly, :monthly]
end
