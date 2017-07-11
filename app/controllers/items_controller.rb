class ItemsController < ApplicationController

  before_action :authorize_admin, only: [:select, :new, :create, :edit, :update, :destroy]
  # To log to the console/log file use
  #     logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  #     logger.tagged("A Tag") {logger.info "the info to output"}

  def index
    @items = Item.available
    @categories = get_sub(Item)
  end

  def select
    @curr_class = curr_selection
    @choices = get_choices(@curr_class)

    if @choices.empty?
       redirect_to "/items/new/#{@curr_class.name}"
    end
  end

  def search
    query = get_query
    if query == nil
      redirect_to root_path
    else
      @items = get_search_results(query)
      @categories = get_sub(Item)
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def category
    @items = get_class_name(params[:class]).available
    @categories = get_sub(Item)
  end

  def new
    @item = get_class_name(params[:class]).new()
    @item_details = get_feature_type(@item)
  end

  def create
    @item = get_item
    @item_details = get_feature_type(@item)
    @item._sku = @item.class.next_sku
    if @item.save
      redirect_to action: 'show', id:  @item._id
    else
      # can add flash messages here if update fails
      redirect_to items_path
    end
  end

  def edit
    @item = Item.find(params[:id])
    @item_details = get_feature_type(@item)
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(valid_features(@item.class))
      redirect_to action: 'show', id:  @item._id
    else
      # can add flash messages here if update fails
      redirect_to items_path
    end

  end

  def destroy
  end

  private 
    def get_sub(class_name)
      '''
      Recursively get a dictionary of the complete class hierarchy
      '''
      sub_classes = class_name.subclasses
      if sub_classes == []
        return {}
      end

      sub_class_hierarchy = {}
      sub_classes.each {|i| sub_class_hierarchy[i.name] = get_sub(i)}
      return sub_class_hierarchy
    end

    def change_delimiter(str,d1 = " ", d2= "")
      # Given a string, replaces 'd1'(default spaces) with 'd2'(default empty)
      str.split(d1).join(d2)
    end

    def get_class_name(str)
      '''
      Changes a given string to one of the valid Item models
      '''
      if (Item.descendants.map { |i| i.name }).include? str
        str.constantize
      else
        Item
      end
    end

    def curr_selection
      '''
      Return a class form params hash. If params hash doesnt have :items keys
      return Item class
      '''
      param_val = params[:item]
      if (param_val == nil)
        return Item
      end
      selection = get_class_name(change_delimiter(params[:item][:group]))
    end

    def get_choices(class_name)
      '''
      Given a class name get a list of all subclass names
      '''
      class_name.subclasses.map {|i| i.name.titleize}
    end

    def get_features(class_name)
      '''
      Given a class name (Item model) get all the fields that need to be filled
      '''
      # ignore internal fields kept by mongoid and fields kept by paperclip
      class_name.fields.keys.select do |field|
        field[0] != "_" && field.split("_")[0] != "image"
      end
    end

    def get_feature_type(class_name)
      '''
      Given a class name (Item model) get all the fields that need to be filled,
      along with their data types.
      '''
      class_features = get_features(class_name)
      all_fields = class_name.fields
      final_map = {}
      class_features.each {|i| final_map[i] = all_fields[i].options[:type]}
      return final_map
    end

    def valid_features(class_name)
      '''
      Permit non-array valid features for a given class in that params hash
      '''
      permitted_features = get_features(class_name).push(:image)
      a = params.require(:item).permit(*permitted_features)
      return a
    end

    def get_array(field_name)
      '''
      Permit array type valid features given the field name
      '''
      restriction_param = params.require(:item).permit(field_name => [])
      restriction_param[field_name]
    end

    def get_item
      '''
      Create an item from params fields (permitting only valid features)
      '''
      class_name = get_class_name(params[:class])
      item = class_name.new(valid_features(class_name))
      features = get_feature_type(class_name)
      features.each {|i,j| j.name == "Array" && item[i] = get_array(i.to_sym)}
      return item
    end

    def get_query
      params[:query]
    end

    def get_all_features
      categories = Item.descendants
      features = []
      categories.each do |category|
        features = features | get_features(category)
      end
      #logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      #logger.tagged("LOG_TAG") {logger.info "#{features}"}
      return features
    end

    def query_db(word)
      features = get_all_features
      features.delete("rentable")
      features.delete("reservable")
      results = Item.where({features[0] => /#{word}/i})
      features.drop(1).each do |feature|
        results = results | Item.where({feature => /#{word}/i})
      end
      return results
    end

    def get_search_results(query)
      words = query.strip.split(" ")
      results = query_db(words[0])
      words.drop(1).each do |word|
        results = results & query_db(word)
      end
      return results
    end

end
