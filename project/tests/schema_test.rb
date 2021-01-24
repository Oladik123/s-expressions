require 'test/unit'
require_relative '../src/schema'

class SchemaTest < Test::Unit::TestCase

  def test_one_element
    parser = Parser.new
    schema = Schema.new(parser.parse('(element (& (name fruits) (type string)))'))
    document = parser.parse('(fruits (@ (fresh true)) "hello")')

    assert_equal(true, schema.validate(document))
  end

  def test_one_element_invalid_type
    parser = Parser.new
    schema = Schema.new(parser.parse('(element (& (name fruits) (type integer)))'))
    document = parser.parse('(fruits "hello")')

    assert_raise(IncorrectTypeException) { schema.validate(document) }
  end

  def test_one_element_invalid_name
    parser = Parser.new
    schema = Schema.new(parser.parse('(element (& (name hobbit) (type string)))'))
    document = parser.parse('(fruits "hello")')

    assert_raise(IncorrectNameException) { schema.validate(document) }
  end

  def test_element
    parser = Parser.new
    document = parser.parse('(fruits (name "apple"))')
    schema = Schema.new(parser.parse('(element (& (name fruits) (type element))
		(element (& (name name)))
		 )'))
    assert_equal(true, schema.validate(document))
  end

  def test_element_with_sequence
    parser = Parser.new
    document = parser.parse('(fruits
	  (fruit
	    (name "apple")
	    (color "green")
	  )
	)')
    schema = Schema.new(parser.parse('(element (& (name fruits) (type element))
		(element (& (name fruit) (type sequence))
	      (element (& (name name)))
	      (element (& (name color)))
	))'))
    assert_equal(true, schema.validate(document))
  end

  def test_sequence
    parser = Parser.new

    document = parser.parse('(fruits (fruit "a") (apple "b")')
    schema = Schema.new(parser.parse('(element (& (name fruits) (type sequence))
	(element (& (name fruit)))
	(element (& (name apple) (type string)))
	 )'))

    assert_equal(true, schema.validate(document))


    document = parser.parse('(fruits
	  (fruit
	    (name "apple")
	    (color "green")
	  )
	(fruit
	    (name "orange")
	    (color "orange")
	  )
	)')
    schema = Schema.new(parser.parse('(element (& (name fruits) (type sequence))
		(element (& (name fruit) (type sequence))
	      (element (& (name name) (type string)))
	      (element (& (name color) (type string)))
	    )
	    (element (& (name fruit) (type sequence))
	      (element (& (name name) (type string)))
	      (element (& (name color) (type string)))
	    ))'))
    assert_equal(true, schema.validate(document))
  end


end