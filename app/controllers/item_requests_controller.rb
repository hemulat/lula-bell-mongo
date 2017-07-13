class ItemRequestsController < ApplicationController
  before_action :authorize_admin, except: [:new]

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
      redirect_to item_requests_path
    end

  private
    def item_params
        params.require(:item_request).permit(:title, :description, :studentID, :created_at)
    end
end
