class TransactionsController < ApplicationController
  before_action :authorize_admin

  def notice
    unreturned = Transaction.where(return_date: nil).desc(:updated_at)
    returned = Transaction.where(:return_date.ne =>  nil).desc(:updated_at)
    @transactions = unreturned+returned
  end

  def check_in
    @transaction = Transaction.find(params[:id])
  end

  def create
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    @transaction = Transaction.new(transaction_params)
    @item = @transaction.item

    start_date = @transaction.start_date
    end_date = @transaction.end_date
    logger.tagged("pick_available return val") {logger.info "#{pick_available(@item,start_date,end_date)}"}
    logger.tagged("item given") {logger.info "#{p @item}"}
    logger.tagged("start_date given") {logger.info "#{start_date}"}
    logger.tagged("end_date given") {logger.info "#{end_date}"}
    picked_id = pick_available(@item,start_date,end_date)
    logger.tagged("Picked ID val") {logger.info "#{picked_id}"}

    if !(picked_id) || picked_id==0
      flash.now[:alert] = "No available item for the given dates!"
      render 'check_out'
      return

    else
      @item._quantity.delete(picked_id)
      @transaction.qty_id = picked_id
      if !@item.rentable
        @item.quantity -= 1
      end
    end

    #Save the object
    if @transaction.save && @item.save
      #If save succeeds, redirect to the index action
      flash[:notice] = "Check out successful."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      render 'check_out'
    end
  end

  def update
    #Find a new object using form parameters
    @transaction = Transaction.find(params[:id])
    @item = @transaction.item
    # update item info
    if (@item.rentable && @transaction.return_date.nil?)
      @item._quantity.push(@transaction.qty_id)
    end 
    # update and persist to DB
    if @transaction.update_attributes(transaction_params) && @item.save
      #If save succeeds, redirect to the show action
      flash[:notice] = "Check in successfully."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      render 'check_in'
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @item = @transaction.item

    # if the transaction is not checked in
    if !@transaction.return_date
      @item._quantity.push(@transaction.qty_id)
      if !@item.rentable
        @item.quantity += 1
      end
    end
    if @transaction.destroy && @item.save
      flash[:notice] = "Transaction destroyed successfully."
    else
      flash[:alert] = "Transaction could not be deleted."
    end

    redirect_to(:action => 'notice')
  end

  def check_out
    @item = Item.find(params[:id])
    @transaction = Transaction.new()
    unless @item.rentable
      @transaction.end_date = Date.today
    end
  end

  private
    def transaction_params
      params.require(:transaction).permit(:student_id, :item_id, :start_date,
                                              :end_date, :return_date, :email)
    end
end
