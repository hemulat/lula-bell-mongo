module ItemsHelper

  def capitalize(str)
    str = str.to_s
    str[0].capitalize + str[1..-1]
  end

  def process_types(feature_type,item)
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    type_map = {"String" => "text", "Mongoid::Boolean"=>"boolean",
                  "Time" => "date", "Array" => "check_boxes"}
    final = {}
    options = item.options

    req_fields = item.class.required_fields

    feature_type.each do |f_name,f_type|
      key = f_name
      value = [options[f_name.to_sym],req_fields.include?(f_name.to_s),
      type_map[f_type.name]]
      final[key] = value
      logger.tagged(key) {logger.info "#{value}"}
    end
    return final
  end
end
