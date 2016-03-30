module SortHelper

  def configuretags
    if params[:tag] != nil && params[:tags] != nil
      @tagstring = params[:tags] + '%' + params[:tag]
    elsif params[:tag] != nil && params[:tags] == nil
      @tagstring = params[:tag]
    else
      @tagstring = ''
    end
  
    @resources, @tags_selected = getresources(@tagstring)
    @tags_selected = alphabetizetags(@tags_selected)

    @tags_left = removeselectedtags(@tags_selected)
    @tags_left = alphabetizetags(@tags_left)
  end

  def getresources(tagstring)
    if tagexists(tagstring)
      tagarray = tagstring.split('%').drop(1)
      tagarray.each do |tagtext|
        newresources = Resource.includes(:tags).where(tags: { text: tagtext })
        newtag = Tag.where(:text => tagtext)
        if @tags == nil
          @tags = newtag
        else
          @tags = @tags + newtag
        end
      end
      @tags = @tags.uniq
      @resources = Resource.all.select {
        |resource|
        !(resource.tags & @tags).empty?
      }
      @resources = @resources.uniq
      return [@resources, @tags]
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

  def alphabetizetags(tags)
    return tags.sort_by {
     |x|
      x.text.downcase
    }
  end
end