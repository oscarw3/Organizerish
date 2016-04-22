  class ReservationsController < ApplicationController
    include ReservationsHelper
    include SortHelper


    
    def index

      @allreservations = Reservation.all 
      @myreservations = Reservation.where(occupied: current_user.id)
      puts "hi"
      puts params
      if params[:commit] == 'Search'
        @rangedata = params[:range]
        @start = DateTime.new(@rangedata["start_date(1i)"].to_i, @rangedata["start_date(2i)"].to_i, @rangedata["start_date(3i)"].to_i, @rangedata["start_date(4i)"].to_i, @rangedata["start_date(5i)"].to_i)
        @end = DateTime.new(@rangedata["end_date(1i)"].to_i, @rangedata["end_date(2i)"].to_i, @rangedata["end_date(3i)"].to_i, @rangedata["end_date(4i)"].to_i, @rangedata["end_date(5i)"].to_i)
        if @start > @end
          redirect_to reservations_path, notice: "Invalid date range!"
        else
          @allreservations = Reservation.all.select {|x| x.starttime >= @start && x.endtime <= @end}
          @myreservations = Reservation.where(occupied: current_user.id).select {|x| x.starttime >= @start && x.endtime <= @end}
        end
      end
      configuretags
      configureresources
    end

    def new

      @reservation = Reservation.new
      @resource = Resource.find(params[:resource])
      if !current_user.create_reservation_permission?(@resource)
        redirect_to reservations_path, notice: "You don't have reservation access to the page!"
      end

    end

    def create

      @reservation = Reservation.new(reservation_params)
      @reservation.isapproved = true
      @reservation.occupied = current_user.id
      params["reservation"]["resource_ids"].each do |resource_id|
        if resource_id != ""
          nextresource = Resource.find(resource_id)
          if !@reservation.resources.include?(nextresource)
            @reservation.resources << nextresource
          end
          if Node.where(:parent_id => resource_id).count == 1
            Node.where(:parent_id => resource_id).first.add_to_reservation(@reservation)
          end
        end
      end
      if @reservation.overlaps?
        flash[:notice] = "Too many simultaneous reservations!"
        redirect_to reservations_path
      elsif @reservation.invalid?
        flash[:notice] = "Invalid time range!"
        redirect_to reservations_path
      elsif @reservation.title == ""
        flash[:notice] = "The reservation needs a title!"
        redirect_to reservations_path
      elsif @reservation.save
        checkrestrictions

        @reservation.save

        if @reservation.isapproved 
          notapprovedarray = @reservation.not_approved_overlaps
          notapprovedarray.each do |reservation|
            ReservationMailer.reservation_unapproved(reservation).deliver_now
            reservation.destroy
          end
          ReservationMailer.reservation_approved(@reservation).deliver_now
        end

        ReservationMailer.delay(:run_at => @reservation.starttime).reservation_start(@reservation)
        redirect_to reservations_path
      else
        redirect_to reservations_path
      end
    end

    def show 
    end

    def edit
      @reservation = Reservation.find(params[:id])
      if !current_user.edit_reservation_permission?(@reservation)
       redirect_to reservations_path, notice: "This isn't your reservation!"
     end
   end

   def update
    @reservation = Reservation.find(params[:id])
    if !current_user.edit_reservation_permission?(@reservation)
     redirect_to reservations_path, notice: "This isn't your reservation!"
   end

   @oldresources = @reservation.resources
   @reservation.clear_resources
   params["reservation"]["resource_ids"].each do |resource_id|
    if resource_id != ""
      nextresource = Resource.find(resource_id)
      if !@reservation.resources.include?(nextresource)
        @reservation.resources << nextresource
      end
      if Node.where(:parent_id => resource_id).count == 1
        Node.where(:parent_id => resource_id).first.add_to_reservation(@reservation)
      end
    end
  end
  if @reservation.overlaps?
    @oldresources.each do |resource| 
      @reservation.resources << resource
    end
    @reservation.save
    flash[:notice] = "This reservation overlaps!"
    redirect_to reservations_path
  elsif @reservation.update(reservation_params)
    @reservation.save
    redirect_to reservations_path
  else
   render 'edit'
 end
end

def destroy
  @reservation = Reservation.find(params[:id])
  if !current_user.edit_reservation_permission?(@reservation)
   redirect_to reservations_path, notice: "This isn't your reservation!"
 end
 ReservationMailer.reservation_deleted(@reservation).deliver_now
 @reservation.destroy
 redirect_to reservations_path
end

def approve
  @reservation = Reservation.find(params[:id])
  @reservation.unapproved_resources.each do |resource|
    resource.groups.each do |group|
      group.users.each do |user|
        if (current_user.id == user.id) || current_user.has_reservation_management?
          @reservation.unapproved_resources.delete(resource)
        end
      end
    end
  end
  if @reservation.unapproved_resources.empty?
    complete
  else
    redirect_to reservations_path
  end
end

def complete
  @reservation = Reservation.find(params[:id])

  notapprovedarray = @reservation.not_approved_overlaps

  notapprovedarray.each do |reservation|
    ReservationMailer.reservation_unapproved(reservation).deliver_now
    reservation.destroy
  end
  ReservationMailer.reservation_approved(@reservation).deliver_now
  @reservation.isapproved = true
  @reservation.save
  redirect_to reservations_path
end

def checkrestrictions
  @reservation.resources.each do |resource|
    if resource.isrestricted?
      @reservation.isapproved = false
    end
    if !current_user.create_reservation_permission?(resource)
      redirect_to reservations_path, notice: "You don't have reservation access to the page!"
    end
  end
  if !@reservation.isapproved
    @reservation.record_unapproved_resources
  end
end

private
def reservation_params
 params.require(:reservation).permit(:starttime, :endtime, :recurring, :resource_ids, :isapproved, :title, :description)
end
end
