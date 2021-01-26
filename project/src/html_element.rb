class Element

  def to_html(depth = 1)
    return "<#{@key.to_s}#{format_attributes_html(get_attributes_html)}#{get_closing_of_opening_tag}" <<
        "#{format_children_html(get_children_html, depth)}" <<
        "#{get_closing_tag(depth)}"
  end

  def format_attributes_html(attributes)
    return (attributes.length == 0 ? '' : ' ') <<
        attributes
            .map { |element| "#{element.get_key}=\"#{element.get_value}\"" }
            .join(" ")
  end

  def get_closing_of_opening_tag
    return (get_children_html.length == 0 ? '/>' : '>') << "\n"
  end

  def format_children_html(children, depth)
    children.map do |child|
      result = " " * 2 * depth
      result << (child.kind_of?(Element) ? child.to_html(depth + 1) : child) << "\n"
    end
        .join
  end

  def get_closing_tag(depth)
    get_children_html.length == 0 ? '' : " " * (depth - 1) * 2 << "</#{@key.to_s}>"
  end

  def get_children_html
    if @data.kind_of?(Array) && has_attributes_html
      return @data[1..-1]
    end

    if @data.kind_of?(Array)
      return @data
    end

    if has_attributes_html
      return []
    end

    return [@data]
  end

  def get_attributes_html
    _attributes = nil

    unless has_attributes_html
      return []
    end

    if @data.kind_of?(Array) && @data.length > 0
      _attributes = @data.first.get_value
    end

    if @data.kind_of?(Element)
      _attributes = @data.get_value
    end

    return _attributes.kind_of?(Element) ? [_attributes] : _attributes
  end

  def has_attributes_html
    attribute_element_key = :"@"
    return @data.kind_of?(Array) && @data.length > 0 && @data.first.get_key == attribute_element_key ||
        @data.kind_of?(Element) && @data.get_key == attribute_element_key
  end
end