class Resource < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :reservations
  has_and_belongs_to_many :groups
  has_many :permissions
  belongs_to :node

  validates :sharing_limit, :numericality => {:greater_than => 0}

  attr_accessor :temp_tags

  def clear_groups
    self.groups.each do |group|
      self.groups.delete(group)
    end
  end

  def storetags
  	#break the list down into multiple tags
  	tagarray = self.temp_tags.split(', ')

    addtags(tagarray)

  end

  def cycle?(parent)
    if self == parent
      return true
    end
    if Node.where(:parent_id => self.id).count == 1
      node = Node.where(:parent_id => self.id).first
      node.resources.each do |child|
        if child.cycle?(parent)
          return true
        end
      end 
    end
    return false
  end


  #takes the tag array and actually adds them
  def addtags(tagarray)
      #remove all current tags
      removealltags

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
        addtag(tag)
      end
    #save resource after iterating
    self.save
  end

  def addtag(tag)
    #if tag is not yet associated with resource, add tag to resource.tags
    if !self.tags.exists?(tag.id)
      self.tags << tag
    end
  end

  def removealltags
      self.tags.each do |tag|
        self.tags.delete(tag)
      end
  end

  def initialize_permissions
    viewaccess = Permission.create(:viewaccess => 1, :reserveaccess => 0)
    reserveaccess = Permission.create(:viewaccess => 0, :reserveaccess => 1)

    self.permissions << viewaccess
    self.permissions << reserveaccess
    self.save
    
  end

  # splits group ids and adds groups to permissions

  def add_to_permissions(array)
    array = array.split("")
    viewgroups = array[0]
    reservegroups = array[1]
    viewaccess = self.permissions.where(viewaccess: 1).where(reserveaccess: 0).first
    viewaccess.remove_groups
    reserveaccess = self.permissions.where(viewaccess: 0).where(reserveaccess: 1).first
    reserveaccess.remove_groups
    viewgroups.each do |id|
      viewaccess.groups << Group.find(id) 
    end

    reservegroups.each do |id|
        reserveaccess.groups << Group.find(id)
    end
    viewaccess.save
    reserveaccess.save
    self.save
  end

  def displaytags
  	tagarray = []
  	self.tags.each do |tag|
  		tagarray << tag.text + ', '
  	end
  	self.temp_tags = tagarray.join
  end

  def delete_permissions
    self.permissions.each do |permission|
      permission.destroy
    end
  end

  def delete_reservations
    self.reservations.each do |reservation|
      ReservationMailer.resource_deleted(reservation).deliver_now
      reservation.destroy
    end
  end
  
end
