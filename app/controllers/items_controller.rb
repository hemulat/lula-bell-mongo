class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(item_params)
    if @item.save
      redirect_to items_path
    else
      redirect_to root_path, alert: 'Item could not be created.'
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image)
  end

end
