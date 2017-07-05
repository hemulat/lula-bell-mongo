class TransactionsController < ApplicationController
  def display
    @items = Item.all
  end

  def notice

  end

  def check_in
    @item = Item.find(params[:id])
    @transaction = Transaction.new()
  end

  def create
    @transaction = Transaction.new(transaction_params)
    #Save the object
    if @item.save
      #If save succeeds, redirect to the index action
      flash[:notice] = "Transaction created successfully."
      redirect_to(:action => 'display')
    else
      #If save fails, redisplay the form so user can fix problems
      render('new') # this renews the form template
    end
  end

  def check_out

  end

  private
  def transaction_params
    params.require(:transaction).permit(:student_id, :start_date, :end_date, :status)
  end
end
