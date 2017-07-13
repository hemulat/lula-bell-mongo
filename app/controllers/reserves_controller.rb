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
      render('new')
    end
  end

  def edit
  end

  def update

  end

  def delete
  end

  def destroy

  end

  private
  def reserve_params
    params.require(:reserve).permit(:student_id, :item_id, :start_date, :end_date, :qty_id, :email)
  end

end
