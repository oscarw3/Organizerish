class Resource < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :reservations

  attr_accessor :temp_tags

  def storetags
  	#break the list down into multiple tags
  	tagarray = self.temp_tags.split(', ')

  	#iterate through array
  		#create tags if they dont exist
  		tagarray.each do |text|
  			tagsearch = Tag.where(:text => text)
  			# if empty, create tag
  			if tagsearch.empty?
  				tag = Tag.create(:text => text)
  			else
  				tag = tagsearch.first
  			end

  			#if tag is not yet associated with resource, add tag to resource.tags
  			if !self.tags.exists?(tag.id)
  				self.tags << tag
  			end
  		end
  		
  		
  		
  	#save resource after iterating
  	self.save

  end

  def displaytags
  	tagarray = []
  	self.tags.each do |tag|
  		tagarray << tag.text + ', '
  	end
  	self.temp_tags = tagarray.join
  end

  def delete_reservations
    self.reservations.each do |reservation|
      ReservationMailer.resource_deleted(reservation).deliver_now
      reservation.destroy
    end
  end
  
end
