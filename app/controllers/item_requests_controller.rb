class ItemRequestsController < ApplicationController
  def index
      @item_requests=ItemRequest.all
    end

    def show
      @item_request = ItemRequest.find(params[:id])
    end

    def new
      @item_request=ItemRequest.new
    end

    def edit
      @item_request = ItemRequest.find(params[:id])
    end

    def create
      @item_request = ItemRequest.new(item_params)
      if @item_request.save
        redirect_to @item_request
      else
        render 'new'
      end
    end

    def destroy
      @item_request = ItemRequest.find(params[:id])
      @item_request.destroy
      redirect_to items_path


end
