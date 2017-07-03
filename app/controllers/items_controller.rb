class ItemsController < ApplicationController
  def index
    @items = Item.where({})
  end

  def select
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    @curr_class = curr_selection
    @choices = get_choices(@curr_class)
    logger.tagged("Select") {logger.info "#{@curr_class} -- #{@choices}"}

    if @choices.empty?
       redirect_to "/items/new/#{@curr_class.name}"
    end
  end


  def new
    @item = get_class_name(params[:class]).new()
    @item_details = get_feature_type(@item)
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    get_feature_type(@item).each do |i,j|
      logger.tagged("Feature - Type") {logger.info "#{i} -- #{j}"}
    end
  end

  def create
    @item = get_item
    @item_details = get_feature_type(@item)
    if @item.save
      redirect_to new_item_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def change_delimiter(str,d1 = " ", d2= "")
      str.split(d1).join(d2)
    end

    def get_class_name(str)
      begin
        return Object.const_defined?(str) ? str.constantize : Item
      rescue
        return Item
      end
    end

    def curr_selection
      param_val = params[:item]
      if (param_val == nil)
        return Item
      end
      selection = get_class_name(change_delimiter(params[:item][:group]))
    end

    def get_choices(class_name)
      class_name.subclasses.map {|i| i.name.titleize}
    end

    def get_features(class_name)
      class_name.fields.keys.select{|field| field[0] != "_"}
    end

    def get_feature_type(class_name)
      class_features = get_features(class_name)
      all_fields = class_name.fields
      final_map = {}
      class_features.each {|i| final_map[i] = all_fields[i].options[:type]}
      return final_map
    end

    def valid_features(class_name)
      logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      permited_features = get_features(class_name)
      permited_features.each {|i| logger.tagged("Only permit") {logger.info "#{i}"}}
      a = params.require(:item).permit(permited_features)
      a.each {|i,j| logger.tagged("Valid features") {logger.info "#{i} -- #{j}"}}
      return a
    end

    def get_item

      class_name = get_class_name(params[:class])
      return class_name.new()
    end
end
