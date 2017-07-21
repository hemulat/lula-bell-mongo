class ReservesController < ApplicationController
  before_action :authorize_admin, except: [:new, :create, :confirm]

  def index
    @reserves = Reserve.all
  end

  def check_out
    reservation = Reserve.find(params[:reserve_id])
    @item = reservation.item
    next_id = pick_different_from(@item,reservation.start_date,reservation.end_date,reservation.qty_id.to_i)
    final_id = reservation.item._quantity.include?(reservation.qty_id.to_i)? reservation.qty_id.to_i : next_id
    if final_id && reservation.item._quantity.include?(final_id)
      @item._quantity.delete(final_id)
      @item.save

      @transaction = Transaction.new
      @transaction.student_id = reservation.student_id
      @transaction.email = reservation.email
      @transaction.end_date = reservation.end_date
      @transaction.start_date = reservation.start_date
      @transaction.item = @item
      @transaction.qty_id = final_id

      @transaction.save
      reservation.destroy
      flash[:notice] = "Item checked out successfully."
    else
      flash[:alert] = "The item you are trying to checkout is already checked out.
                        Most likely not returned after a checkout."
    end
    redirect_to reserves_path
  end

  def show
    @reserve = Reserve.find(params[:id])
  end

  def confirm
  end

  def new
    @item = Item.find(params[:item_id])
    @reserve = Reserve.new()
  end

  def create

    @reserve = Reserve.new(reserve_params)
    @item = @reserve.item

    qty_id = pick_available(@item,@reserve.start_date,@reserve.end_date)
    if !qty_id
      #if reservation is not possible, redisplay form so user can change Dates
      flash.now[:alert] = "Reservation for the selected times is not possible,
      please select different dates!"
      render 'new'
      return
    end

    @reserve.qty_id = qty_id
    if @reserve.save
      #If save succeeds, show confirmation
      flash[:notice] = "Reservation created successfully."
      redirect_to(:action => 'confirm')
    else
      #If save fails, redisplay the form so user can fix problems
      render 'new'
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
      flash.now[:notice] = "You need to have:
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
