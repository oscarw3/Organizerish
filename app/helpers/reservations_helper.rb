module ReservationsHelper
	def getresources(tagstring)
		
		if tagexists(tagstring)
			tagarray = tagstring.split('%').drop(1)
			tagarray.each do |tagtext|
				newresources = Resource.includes(:tags).where(tags: { text: tagtext })
        newtag = Tag.where(:text => tagtext)
				if @resources == nil
					@resources = newresources
          @tags = newtag
				else
              @tags = @tags + newtag
      				@resources = @resources + newresources
      			end
      		end
   			return [@resources.uniq, @tags.uniq]
      	else
      		return Resource.all, Tag.none 
      	end
    end

    def tagexists(tagstring)
    	if tagstring != ''
    		return true
    	else
    		return false
    	end
    end

    def removeselectedtags(selectedtags)
      if selectedtags != nil
        return Tag.all - selectedtags
      else
        return Tag.all
      end
    end
end
