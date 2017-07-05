class ItemsController < ApplicationController

  # To log to the console/log file use
  #     logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  #     logger.tagged("A Tag") {logger.info "the info to output"}

  def index
    @items = Item.where({})
  end

  def select
    @curr_class = curr_selection
    @choices = get_choices(@curr_class)

    if @choices.empty?
       redirect_to "/items/new/#{@curr_class.name}"
    end
  end


  def new
    @item = get_class_name(params[:class]).new()
    @item_details = get_feature_type(@item)
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
      permited_features = get_features(class_name)
      a = params.require(:item).permit(*permited_features)
      return a
    end

    def get_array(field_name)
      restriction_param = params.require(:item).permit(field_name => [])
      restriction_param[field_name]
    end

    def get_item
      class_name = get_class_name(params[:class])
      item = class_name.new(valid_features(class_name))
      features = get_feature_type(class_name)
      features.each {|i,j| j.name == "Array" && item[i] = get_array(i.to_sym)}
      return item
    end
end
