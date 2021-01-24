require_relative 'element'
require_relative 'validator'

class Parser

  REPLACEMENT = '__INTERNAL_STRING_REPLACEMENT__'

  # Parse s-expression string into Element class
  # @param string
  # @return Element
  def parse (string)
    string, string_literals = self.extract_string_atoms(string)
    token_array = tokenize_string(string)
    token_array = restore_string_literals(token_array, string_literals)
    token_array = convert_tokens(token_array)
    s_expression = re_structure(token_array)[1]
    s_expression = s_expression.first

    transform_to_elements(s_expression)
  end

  # Build original string with replaced string atoms, and string atoms
  # @param string string
  # @return array
  def extract_string_atoms (string)
    string_literals = []
    string_literal_pattern = /"[^"].*?"/
    # extract strings
    string.gsub(string_literal_pattern) { |x|
      string_literals << x
    }
    # replace strings
    string = string.gsub(string_literal_pattern, REPLACEMENT)

    [string, string_literals]
  end


  # Add spaces around parentheses
  # @param string string
  # @return array
  def tokenize_string (string)
    string = string.gsub('(', ' ( ')
    string = string.gsub(')', ' ) ')
    string.split(' ')
  end

  # @param token_array array
  # @param string_literals array
  def restore_string_literals (token_array, string_literals)
    token_array.map { |x|
      if x == REPLACEMENT
        string_literals.shift
      else
        x
      end
    }
  end

  # @param token_array array
  def convert_tokens(token_array)
    converted_tokens = []
    token_array.each do |t|
      converted_tokens << '(' and next if (t == '(')
      converted_tokens << ')' and next if (t == ')')
      converted_tokens << t.to_i and next if (Validator.is_integer_literal?(t))
      converted_tokens << (t == 'true') and next if (Validator.is_boolean_literal?(t))
      converted_tokens << t.to_sym and next if (Validator.is_symbol?(t))
      converted_tokens << t.to_s and next if (Validator.is_string_literal?(t))
      # If we haven't recognized the token by now we need to raise
      # an exception as there are no more rules left to check against!
      raise Exception, "Unrecognized token: #{t}!"
    end

    converted_tokens
  end

  # @param token_array array
  # @param offset integer
  def re_structure(token_array, offset = 0)
    struct = []
    while offset < token_array.length
      if token_array[offset] == '('
        # Multiple assignment from the array that re_structure() returns
        offset, tmp_array = re_structure(token_array, offset + 1)
        struct << tmp_array
      elsif token_array[offset] == ')'
        break
      else
        struct << token_array[offset]
      end
      offset += 1
    end

    [offset, struct]
  end

  # @param elements_array array
  # @return Element
  def transform_to_elements (elements_array)
    key = elements_array.first
    values = elements_array[1..-1]

    elements = []
    if values && values.count
      values.each { |x|
        if x.kind_of?(Array)
          if values.count == 1
            elements = transform_to_elements(x)
          else
            elements << transform_to_elements(x)
          end

        else
          elements = x
        end
      }
    end

    Element.new(key, elements)
  end

end