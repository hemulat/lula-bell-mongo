class ReservesController < ApplicationController

  def index
    @reserves = Reserve.all
  end

  def show
    @reserve = Reserve.find(params[:id])
  end

  def confirm
  end

  def new
    @item = Item.find(params[:id])
    @reserve = Reserve.new()
  end

  def create
    @reserve = Reserve.new(reserve_params)
    #Save the object
    if @reserve.save
      #If save succeeds, redirect to the index action
      flash[:notice] = "Reservation created successfully."
      redirect_to(:action => 'confirm')
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:notice] = "Please enter your 9-digit student id, email, and dates."
      redirect_back(fallback_location: root_path )
    end
  end

  def edit
    @reserve = Reserve.find(params[:id])
  end

  def update
    #Find a new object using form parameters
    @reserve = Reserve.find(params[:id])
    #Update the object
    if @reserve.update_attributes(reserve_params)
      #If save succeeds, redirect to the show action
      flash[:notice] = "Reserve updated successfully."
      redirect_to(:action => 'index')
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:notice] = "You need to have:
      Dates, 9-digit Student ID, Student's email"
      render('edit') # this renews the form template
    end
  end

  def delete
    @reserve = Reserve.find(params[:id])
  end

  def destroy
    @reserve = Reserve.find(params[:id])
    @reserve.destroy

    flash[:notice] = "Reservation destroyed successfully."
    redirect_to(:action => 'index')
  end

  private
  def reserve_params
    params.require(:reserve).permit(:student_id, :item_id, :start_date, :end_date, :qty_id, :email)
  end

end
