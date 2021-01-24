# Helper class for validation
class Validator

  # Check that string is valid parenthesis sequence
  # @note complexity: O(n)
  # @param string string
  # @return boolean
  def self.is_valid_brackets? (string)
    depth = 0
    string.each_char { |c|
      depth -= 1 if (c == ')')
      depth += 1 if (c == '(')
      return false if (depth < 0)
    }
    return false if depth != 0
    return true
  end

  # @param string string
  # @param string pattern
  # @return boolean
  def self.is_match?(string, pattern)
    match = string.match(pattern)
    return false unless match
    match[0].length == string.length
  end

  # @param string string
  # @return boolean
  def self.is_symbol? (string)
    return false if self.is_boolean_literal?(string)
    is_match?(string, /[^\"\'\,\(\)]+/)
  end

  # @param string string
  # @return boolean
  def self.is_integer_literal?(string)
    # Any number of numerals optionally preceded by a plus or minus sign
    is_match?(string, /[\-\+]?[0-9]+/)
  end

  # @param string string
  # @return boolean
  def self.is_boolean_literal? (string)
    res = string == 'true' || string == 'false'
    res
  end

  # @param string string
  # @return boolean
  def self.is_string_literal?(string)
    is_match?(string, /"([^"\\]|\\.)*"/)
  end

end