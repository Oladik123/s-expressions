class Element

  def to_html(depth = 0)
    result = '<' << @key.to_s

    if @data == nil || (@data.kind_of?(Array) && @data.length == 0)
      return result << ' />'
    end

    if @data.kind_of?(Element) && @data.get_key == :"@"
      return result << ' ' << to_key_value(@data.get_value) << '/>'
    end

    if @data.kind_of?(Element)
      return result << ">\n" << @data.to_html(depth + 1) << "\n</#{@key.to_s}>"
    end

    if @data.kind_of?(Array)
      _data = @data
      if _data.first.kind_of?(Element) && _data.first.get_key == :"@"
        result << ' ' << to_key_value(_data.first.get_value)
        _data = _data[1..-1]
      end

      return result << ">\n" <<
        _data.map { |element| element.to_html(depth + 1) }.join("\n") <<
        "\n</#{@key.to_s}>"
    end

    return result << ">\n" << @data.to_s << "\n</#{@key.to_s}>"
  end

  private def to_key_value(element_or_array)
    elements = element_or_array.kind_of?(Array) ? element_or_array : [element_or_array]
    return elements.map { |element| "#{element.get_key}=\"#{element.get_value}\"" }
                   .join(" ")
  end

end