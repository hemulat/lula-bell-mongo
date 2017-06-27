class ItemsController < ApplicationController
  def index
    @items = Item.find()
  end

  def select
    @curr_class = curr_selection
    @choices = @curr_class.subclasses.map {|i| i.name.split("_").join(" ")}
    logger.debug "#{@curr_class} -- #{@choices}"

    if @choices.empty?
      render 'new'
    end

  end


  def new
    @item = @curr_class.new()
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def curr_selection
      param_val = params[:items]
      if (param_val == nil)
        return Item
      else
        selection = eval(params[:items][:group].split(" ").join("_"))
        return selection
      end
    end
end
