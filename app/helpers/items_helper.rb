module ItemsHelper

  def capitalize(str)
    str = str.to_s
    str_list = str.split("_")
    final = ""
    str_list.each {|s| final += s[0].capitalize + s[1..-1]+" "}
    return final
  end

  def explanation(item,field)
    exp = item.explanations[field.to_sym]
    if exp.nil?
      return ""
    else
      return " (#{exp})"
    end
  end

  def not_empty(str)
    if (Item.descendants.map { |i| i.name }).include? str
      item_count = (str.constantize).all.count
      return item_count != 0
    end
    return false
  end

  def process_types(feature_type,item)
    # final will be key-value. key is field name and value is
    # [options(Array),required(boolean),Type]
    type_map = {"String" => "string", "Mongoid::Boolean"=>"boolean",
                  "Time" => "date", "Array" => "check_boxes",
                  "Integer" => "integer"}
    final = {}
    options = item.options

    req_fields = item.class.required_fields

    feature_type.each do |f_name,f_type|
      key = f_name
      value = [options[f_name.to_sym],req_fields.include?(f_name.to_s)]
      field_type = (f_name.downcase == "description" ? "text" : type_map[f_type.name])
      value.push(field_type)
      final[key] = value
    end
    return final
  end
end
