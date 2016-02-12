module ReservationsHelper
	def getresources(tagstring)
		
		if tagexists(tagstring)
			tagarray = tagstring.split('%').drop(1)
			tagarray.each do |tagtext|
				newresources = Resource.includes(:tags).where(tags: { text: tagtext })
				if @resources == nil
					@resources = newresources
				else
      				@resources = @resources + newresources
      			end
      		end
   			return @resources.uniq
      	else
      		return Resource.all
      	end
    end

    def tagexists(tagstring)
    	if tagstring != ''
    		return true
    	else
    		return false
    	end
    end
end
