require_relative 'element'
require_relative 'parser'

# Exception that indicate element type mismatch
class IncorrectTypeException < Exception
end

# Exception that indicate element name mismatch
class IncorrectNameException < Exception
end

# Class for validate element schema
class Schema

  @schema = nil

  # @param schema Element
  def initialize(schema)
    @schema = schema
  end

  # @param document Element
  # @return boolean
  def validate(document)
    schema = @schema
    while !schema.nil? do
      #puts "=Schema " + schema.inspect
      #puts "=Document: " + document.inspect
      if schema.kind_of?(Array)
        schema.zip(document).each do |schema_element, current_doc_node_element|
          #puts schema_element.get_types.inspect
          #puts current_doc_node_element.inspect
          check_types(schema_element.get_types, current_doc_node_element)
        end
        break
      else
        check_types(schema.get_types, document)
        schema = schema.get_value
        document = document.get_value
      end
    end

    true
  end

  private

  # @param types array
  # @param element Element
  def check_types(types, element)
    types.each { |x|
      #puts "Element " + x.inspect
      #puts "Current doc node " + element.inspect
      if x.get_key == :name
        if element.get_key != x.get_value
          raise IncorrectNameException, "Incorrect name. Expected #{x.get_value.to_s}, actual = #{element.get_key.to_s}"
        end
      end
      if x.get_key == :type
        if element.get_type != x.get_value
          raise IncorrectTypeException, "Incorrect type. Expected #{x.get_value.to_s}, actual = #{element.get_type.to_s}"
        end
      end
    }
  end

end