class TransactionsController < ApplicationController
  before_action :authorize_admin

  def notice
    unreturned = Transaction.where(return_date: nil).desc(:updated_at)
    returned = Transaction.where(:return_date.ne =>  nil).desc(:updated_at)
    @transactions = unreturned+returned
  end

  def create
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    @transaction = Transaction.new(transaction_params)
    @item = @transaction.item

    start_date = @transaction.start_date
    @transaction.end_date ||=  @transaction.start_date
    end_date = @transaction.end_date
    picked_id = pick_available_checkout(@item,start_date,end_date)

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

  def check_in
    @transaction = Transaction.find(params[:id])
  end

  def update
    #Find a new object using form parameters
    @transaction = Transaction.find(params[:id])
    @item = @transaction.item
    # update and persist to DB
    if @transaction.update_attributes(transaction_params)
      #If save succeeds, redirect to the show action
      flash[:notice] = "Transaction updated successfully."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      render 'check_in'
    end
  end

  def direct_checkin
    #Find a new object using form parameters
    @transaction = Transaction.find(params[:id])
    @item = @transaction.item
    # update item info
    if (@item.rentable && @transaction.return_date.nil?)
      @item._quantity.push(@transaction.qty_id)
    end

    @transaction.return_date = DateTime.now

    if @transaction.save && @item.save
      flash[:notice] = "Check in successfully."
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:alert] = "Check in failed"
    end
    redirect_to(:action => 'notice')
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

  def multiple_check_out
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.tagged("A Tag") {logger.info "#{params.inspect}"}

    if params.has_key?(:sku)
      @item = Item.find_by(_SKU: params[:sku])

      if params.has_key?(:start_date) && params[:start_date][0] != ""
        transaction = Transaction.new
        transaction.student_id = params[:student_id]
        transaction.item_id = @item._id
        transaction.start_date = params[:start_date][0]
        if @item.rentable
          if !params.has_key?(:end_date) || params[:end_date][0] == ""
            redirect_to multiple_check_out_path(:student_id => params[:student_id], :sku => params[:sku]), alert: "End date cannot be empty!"
            return
          end
          transaction.end_date = params[:end_date][0]
        else
          transaction.end_date = transaction.start_date
        end

        picked_id = pick_available_checkout(@item, transaction.start_date, transaction.end_date)
        if !(picked_id) || picked_id==0
          redirect_to multiple_check_out_path(:student_id => params[:student_id], :sku => params[:sku]), alert: "No available item for the given dates!"
          return
        else
          @item._quantity.delete(picked_id)
          transaction.qty_id = picked_id
          if !@item.rentable
            @item.quantity -= 1
          end
        end

        if transaction.save && @item.save
          redirect_to multiple_check_out_path(:student_id => params[:student_id]), notice: "Successfully checked out!"
          return
        end
        elsif params.has_key?(:start_date) && params[:start_date][0] == ""
          redirect_to multiple_check_out_path(:student_id => params[:student_id], :sku => params[:sku]), alert: "Start date cannot be empty!"
        end
      end
    end

  def student_check_in
    #just form for Student id
  end

  def student_item_check
    @transactions = Transaction.where(:student_id => params[:input])
  end

  def edit_multiple
    @transactions = Transaction.find(params[:items_id])
  end

  def update_multiple
    @transactions = Transaction.find(params[:items_id])
    @transactions.each do |transaction|
      transaction.update_attributes!(params[:transaction].reject {|k,v| v.blank? })
    end
    flash[:notice] = "Your items have been checked in!"
    redirect_to(transactions_path)
  end
  
  private
    def transaction_params
      params.require(:transaction).permit(:student_id, :item_id, :start_date,
                                              :end_date, :return_date, :email)
    end
end
