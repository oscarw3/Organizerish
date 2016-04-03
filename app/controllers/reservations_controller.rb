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
    puts @reservation.resources.size
  	@reservation.occupied = current_user.id
      if @reservation.overlaps?
          flash[:notice] = "This reservation overlaps!"
          redirect_to reservations_path
      elsif @reservation.save
        params["reservation"]["resource_ids"].each do |resource_id|
          if resource_id != ""
            @reservation.resources << Resource.find(resource_id)
          end
        end


    @reservation.resources.each do |resource|

      #Check if any of the resources are restricted


      if resource.isrestricted?
        @reservation.isapproved = false
      end

      if !current_user.create_reservation_permission?(resource)
        redirect_to reservations_path, notice: "You don't have reservation access to the page!"
      end
      
    end 

    @reservation.save

    if @reservation.isapproved 
      notapprovedarray = @reservation.not_approved_overlaps

      notapprovedarray.each do |reservation|
        #delete and email
        ReservationMailer.reservation_unapproved(@reservation)
        reservation.destroy
      end
    end

    ReservationMailer.delay(:run_at => @reservation.starttime).reservation_start(@reservation) 
    redirect_to reservations_path
    else
    	render 'new'
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
      if @reservation.overlaps?
        flash[:notice] = "This reservation overlaps!"
        redirect_to reservations_path
    	elsif @reservation.update(reservation_params)
          @reservation.clear_resources
          params["reservation"]["resource_ids"].each do |resource_id|
            if resource_id != ""
              @reservation.resources << Resource.find(resource_id)
            end
          end
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
    	@reservation.destroy
 
    	redirect_to reservations_path
	end

  def approve
    puts "APPROVE METHOD CALLED"

    @reservation = Reservation.find(params[:id])
    @reservation.isapproved = true
    @reservation.save

    notapprovedarray = @reservation.not_approved_overlaps

    notapprovedarray.each do |reservation|
      #delete and email
      reservation.destroy
    end






    redirect_to reservations_path

  end


	private
  	def reservation_params
    	params.require(:reservation).permit(:starttime, :endtime, :recurring, :resource_ids, :isapproved, :title, :description)
  	end
end
