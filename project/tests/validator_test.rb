require 'test/unit'
require_relative '../src/validator'

class ValidatorTest < Test::Unit::TestCase

  def test_is_valid_brackets
    assert_equal(true, Validator.is_valid_brackets?('(a (b (c)))'))
    assert_equal(false, Validator.is_valid_brackets?('(a )b (c)))'))
    assert_equal(false, Validator.is_valid_brackets?(')a)b)c)'))
    assert_equal(false, Validator.is_valid_brackets?('(a ((()'))
  end

  def test_is_integer
    assert_equal(true, Validator.is_integer_literal?('1'))
    assert_equal(true, Validator.is_integer_literal?('+1'))
    assert_equal(true, Validator.is_integer_literal?('-1'))
    assert_equal(false, Validator.is_integer_literal?('-1.23'))
    assert_equal(false, Validator.is_integer_literal?('-asd'))
  end

  def test_is_boolean
    assert_equal(true, Validator.is_boolean_literal?('false'))
    assert_equal(true, Validator.is_boolean_literal?('true'))
    assert_equal(false, Validator.is_boolean_literal?('tru2e'))
  end

  def test_is_symbol
    assert_equal(false, Validator.is_symbol?("'"))
    assert_equal(false, Validator.is_symbol?("\""))
    assert_equal(true, Validator.is_symbol?('fal2'))
    assert_equal(true, Validator.is_symbol?('A'))
  end

end