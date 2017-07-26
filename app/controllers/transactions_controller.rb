class TransactionsController < ApplicationController
  before_action :authorize_admin

  def notice
    unreturned = Transaction.where(return_date: nil).desc(:updated_at)
    #returned = Transaction.where(:return_date.ne =>  nil).desc(:updated_at)
    @transactions = returns_only(unreturned)
  end

  def display
    unreturned = Transaction.where(return_date: nil).desc(:updated_at)
    returned = Transaction.where(:return_date.ne =>  nil).desc(:updated_at)
    nonreturn = non_returns_only(unreturned)

    @transactions = returned + nonreturn
  end

  def create
    qty_tosave = params[:quantity].to_i
    @transaction = Transaction.new(transaction_params)

    if check_out_n_items(qty_tosave)
      flash[:notice] = "Check out successful."
      redirect_to(:action => 'notice')
      return
    else
        flash.now[:alert] = "Couldn't find #{qty_tosave} " +
                            "#{'item'.pluralize(qty_tosave)} for " +
                            "the given dates!"
        @item = Item.find(params.require(:transaction)[:item_id])
        render 'check_out'
        return
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
    transaction = Transaction.find(params[:id])
    if checkin_transaction(transaction)
      flash[:notice] = "Checked in successfully."
    else
      flash[:alert] = "Check in failed." # this should never happen
    end
    redirect_back fallback_location: {action: 'notice'}
  end

  def destroy
    transaction = Transaction.find(params[:id])
    result = delete_transaction(transaction)
    if result
      flash[:notice] = "Transaction destroyed successfully."
    else
      flash[:alert] = "Transaction could not be deleted."
    end
    redirect_back fallback_location: {action: 'notice'}
  end

  def student
    #just form for Student id (just input for student id)
  end

  def student_items
    std_id = params[:input]
    redirect_to student_activity_path(std_id)
  end

  def student_transactions
    @transactions  = Transaction.where(student_id: params[:id]).all
  end


  def check_out
    @item = Item.find(params[:id])
    @transaction = Transaction.new()
  end

  def multiple_check_out
    if params.has_key?(:transaction)
      @transaction = Transaction.new(transaction_params)
    else
      @transaction = Transaction.new()
    end

    if params.has_key?(:sku)
      @item = Item.find_by(_SKU: params[:sku])

      if params.has_key?(:checkout)
        if @item.rentable
          if params[:transaction][:end_date] == ""
            redirect_to multiple_check_out_path(transaction: transaction_params,
                                                sku: params[:sku], qty: params[:qty]),
                                                alert: "End date cannot be empty!"
            return
          end
          if params[:transaction][:email] == ""
            redirect_to multiple_check_out_path(transaction: transaction_params,
                                                sku: params[:sku], qty: params[:qty]),
                                                alert: "Email is required for rentable items!"
            return
          end
        end

        qty = params[:qty].to_i
        if check_out_n_items(qty)
          redirect_to multiple_check_out_path(transaction: transaction_params),
                                              notice: "Checked out successfully!"
        else
          redirect_to multiple_check_out_path(transaction: transaction_params,
                                              sku: params[:sku], qty: params[:qty]),
                                              alert: "Items not available for the given dates!"
        end
      end# end of !if params key
    end # end of if params key
  end #end of method

  private
    def transaction_params
      params.require(:transaction).permit(:student_id, :item_id, :start_date,
                                              :end_date, :return_date, :email)
    end

    def returns_only(transactions)
      returnables = []
      transactions.each do |t|
        if t.item.rentable
          returnables << t
        end
      end

      return returnables
    end

    def non_returns_only(transactions)
      returnables = []
      transactions.each do |t|
        unless t.item.rentable
          returnables << t
        end
      end

      return returnables
    end

    def delete_transaction(transaction)
      item = transaction.item
      # if the transaction is not checked in
      if transaction.return_date.nil?
        item._quantity.push(transaction.qty_id)
        if !item.rentable
          item.quantity += 1
        end
      end

      return transaction.destroy && item.save
    end

    def checkin_transaction(transaction)
      item = transaction.item
      # update item info
      if (item.rentable && transaction.return_date.nil?)
        item._quantity.push(transaction.qty_id)
      end

      transaction.return_date = DateTime.now

      return transaction.save && item.save
    end

    def check_out_unrentable(transaction,item)
      picked_id = item._quantity.pop()
      if picked_id.nil?
        return false
      else
        transaction.qty_id = picked_id
        item.quantity -= 1
        return (transaction.save && item.save)
      end
    end

    def check_out_rentable(transaction,item)
      start_date = transaction.start_date
      end_date = transaction.end_date

      picked_id = pick_available_checkout(item,start_date,end_date)

      if !(picked_id)
        return false
      else
        item._quantity.delete(picked_id)
        transaction.qty_id = picked_id
        return (transaction.save && item.save)
      end
    end

    def undo_transactions(transactions)
      transactions.each do |t|
        t.destroy
      end
    end

    def check_out_n_items(qty_tosave)
      saved_transactions = []
      saved_qtys = []
      (1..qty_tosave).each do
        transaction = Transaction.new(transaction_params)
        item = @transaction.item
        if item.rentable
          result = check_out_rentable(transaction,item)
        else
          result = check_out_unrentable(transaction,item)
        end

        if result
          saved_transactions.push(transaction)
          saved_qtys.push(transaction.qty_id)
        else
          undo_transactions(saved_transactions)
          item._quantity += saved_qtys
          if !item.rentable
            item.quantity += saved_qtys.size
          end
          item.save
          return false
        end
      end
      return true
    end

end
