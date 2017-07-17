class TransactionsController < ApplicationController

  before_action :authorize_admin

  def display
    @items = Item.all
  end

  def notice
    @transactions = Transaction.all.order_by(:updated_at => 'desc')
  end

  def check_in
    @transaction = Transaction.find(params[:id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @item = @transaction.item

    @item = @transaction.item
    if @item._quantity.empty?
      flash[:alert] = "Out of stock!"
      render 'check_out'
      return
    else
      @transaction.qty_id = @item._quantity.pop()
      if !@item.rentable
        @item.quantity -= 1
      end
    end

    #Save the object
    if @transaction.save && @item.save
      #If save succeeds, redirect to the index action
      flash[:notice] = "Transaction created successfully."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:notice] = "Check out failed.
      Please provide 9-digit Student Id and Date(s)."
      redirect_to(:action => 'display')
    end
  end

  def update
    #Find a new object using form parameters
    @transaction = Transaction.find(params[:id])
    @item = @transaction.item
    # update item info
    @item._quantity.push(@transaction.qty_id)

    # update and persist to DB
    if @transaction.update_attributes(transaction_params) && @item.save
      #If save succeeds, redirect to the show action
      flash[:notice] = "Transaction updated successfully."
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
      params.require(:transaction).permit(:student_id, :item_id, :start_date, :end_date, :return_date)
    end
end
