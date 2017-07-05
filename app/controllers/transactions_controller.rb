class TransactionsController < ApplicationController
  def display
    @items = Item.all
  end

  def notice

  end

  def check_in
    @item = Item.find(params[:id])
  end

  def check_out

  end
end
