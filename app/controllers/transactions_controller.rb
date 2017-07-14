class TransactionsController < ApplicationController
  before_action :authorize_admin

  def notice
    @transactions = Transaction.all.order_by(:updated_at => 'desc')
  end

  def check_in
    @transaction = Transaction.find(params[:id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    #Save the object
    if @transaction.save
      #If save succeeds, redirect to the index action
      flash[:notice] = "Transaction created successfully."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      @item = @transaction.item
      render 'check_out'
    end
  end

  def update
    #Find a new object using form parameters
    @transaction = Transaction.find(params[:id])
    #Update the object
    if @transaction.update_attributes(transaction_params)
      #If save succeeds, redirect to the show action
      flash[:notice] = "Transaction updated successfully."
      redirect_to(:action => 'notice')
    else
      #If save fails, redisplay the form so user can fix problems
      render 'check_in'
    end
  end

  def delete
    @transaction = Transaction.find(params[:id])
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    flash[:notice] = "Transaction destroyed successfully."
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
