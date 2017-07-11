class ItemsController < ApplicationController

  before_action :authorize_admin, only: [:select, :new, :create, :edit, :update, :destroy]
  # To log to the console/log file use
  #     logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  #     logger.tagged("A Tag") {logger.info "the info to output"}

  def index
    @items = Item.available
    @categories = Item.subclasses.map{|i| i.name} #get_sub(Item)
  end

  def select
    @curr_class = curr_selection
    @choices = get_choices(@curr_class)

    if @choices.empty? # can add flash messages here
       redirect_to "/items/new/#{@curr_class.name}"
    end
  end

  def search
    query = get_query
    if query == nil
      redirect_to root_path
    else
      @items = get_search_results(query)
      @categories = Item.subclasses.map{|i| i.name}
    end
  end

  def show
    @item = Item.find(params[:id])
    @features = get_features(@item.class)
    @features.delete("name")
    @features.delete("description")
    if !admin_signed_in?
      @features.delete("rentable")
      @features.delete("reservable")
    end
  end

  def category
    @items = get_class_name(params[:class]).available
    @categories = Item.subclasses.map{|i| i.name}
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

  def get_features(class_name)
    # ignore internal fields kept by mongoid and fields kept by paperclip
    class_name.fields.keys.select do |field|
      field[0] != "_" && field.split("_")[0] != "image"
    end
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
      # ignore internal fields kept by mongoid and fields kept by paperclip
      class_name.fields.keys.select do |field|
        field[0] != "_" && field.split("_")[0] != "image"
      end
    end

    def get_feature_type(class_name)
      class_features = get_features(class_name)
      all_fields = class_name.fields
      final_map = {}
      class_features.each {|i| final_map[i] = all_fields[i].options[:type]}
      return final_map
    end

    def valid_features(class_name)
      permitted_features = get_features(class_name).push(:image)
      a = params.require(:item).permit(*permitted_features)
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

    # Gets search query
    def get_query
      params[:query]
    end

    # Gets all features from all subclasses of Item
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

    # Queries database with single word
    def query_db(word)
      features = get_all_features
      features.delete("rentable")
      features.delete("reservable")
      results = Item.where({features[0] => /#{word}/i})
      features.drop(1).each do |feature|
        results = Item.or(results.selector, Item.where({feature => /#{word}/i}).selector)
      end
      return results
    end

    # Queries database with multiple words
    def get_search_results(query)
      words = query.strip.split(" ")
      results = query_db(words[0])
      words.drop(1).each do |word|
        results = Item.and(results.selector, query_db(word).selector)
      end
      return results
    end

end
