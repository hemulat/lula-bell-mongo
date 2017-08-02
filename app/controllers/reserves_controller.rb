class ReservesController < ApplicationController
  before_action :authorize_admin, except: [:new, :create, :confirm]

  def index
    @reserves = Reserve.all
  end

  def check_out
    reservation = Reserve.find(params[:reserve_id])
    @item = reservation.item
    next_id = pick_different_from(@item,reservation.start_date,
                                  reservation.end_date,reservation.qty_id.to_i)
    final_id = reservation.item._quantity.include?(reservation.qty_id.to_i)? reservation.qty_id.to_i : next_id
    if final_id && reservation.item._quantity.include?(final_id)
      @item._quantity.delete(final_id)
      @item.save

      @transaction = Transaction.new(reservation.attributes.slice(:student_id,
                                :email,:end_date,:start_date,:item_id))
      @transaction.qty_id = final_id
      @transaction.save
      reservation.destroy
      flash[:notice] = "Item checked out successfully."
    else
      flash[:alert] = "The item you are trying to checkout is already checked out.
                        Most likely not returned after a checkout."
    end
    redirect_back fallback_location: reserves_path
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
      redirect_to item_path(@reserve.item_id)
    else
      #If save fails, redisplay the form so user can fix problems
      render 'new'
    end
  end

  def edit
    @reserve = Reserve.find(params[:id])
    @item  = @reserve.item
  end

  def update
    #Find a new object using form parameters
    @reserve = Reserve.find(params[:id])
    @item  = @reserve.item
    new_start_date = reserve_params[:start_date]
    new_end_date = reserve_params[:end_date]
    #Update the object
    if (can_extend_reserve(@reserve, new_start_date, new_end_date) &&
        @reserve.update_attributes(reserve_params))
      #If save succeeds, redirect to the show action
      flash[:notice] = "Reservation updated successfully."
      redirect_to item_transactions_path(@item)
    else
      #If save fails, redisplay the form so user can fix problems
      if !@reserve.errors.any?
        flash.now[:alert] = "The time you choose is not be viable"
      end
      render('edit') # this renews the form template
    end
  end

  def destroy
    @reserve = Reserve.find(params[:id])
    @reserve.destroy

    flash[:notice] = "Reservation destroyed successfully."
    redirect_back fallback_location: reserves_path
  end

  private
  def reserve_params
    params.require(:reserve).permit(:student_id, :item_id, :start_date, :end_date, :qty_id, :email)
  end

end
