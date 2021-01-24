require 'test/unit'
require_relative '../src/parser'

class ParserTest < Test::Unit::TestCase

  def test_parse_is_empty
    parser = Parser.new

    assert_equal(true, parser.parse('()').is_empty?)
    assert_equal(false, parser.parse('(f)').is_empty?)
  end

  def test_parse_simple
    parser = Parser.new

    assert_equal(Element.new('f', []).inspect, parser.parse('(f)').inspect)
    assert_equal(Element.new('f',
                             Element.new('key', :value)).inspect,
                 parser.parse('(f (key value))').inspect
    )
    assert_equal(
        Element.new('f', [Element.new('key', :value), Element.new('key2', :value2)]).inspect,
        parser.parse('(f (key value) (key2 value2))').inspect
    )
  end

  def test_parse
    parser = Parser.new

    assert_equal(
        Element.new('fruits', Element.new('fruit', [
            Element.new('@', Element.new('fresh', true)),
            Element.new('name', '"apple"')
        ])).inspect,
        parser.parse('(fruits
			  (fruit (@ (fresh true))
			    (name "apple")
			  )
			)').inspect
    )

    assert_equal(
        Element.new('fruits', [
            Element.new('fruit', [
                Element.new('@', [
                    Element.new('fresh', true),
                    Element.new('weight', 5)
                ]),
                Element.new('name', '"apple"'),
                Element.new('color', '"green"')
            ]),
            Element.new('fruit', [
                Element.new('@', [
                    Element.new('fresh', false),
                    Element.new('weight', -10)
                ]),
                Element.new('name', '"orange"'),
                Element.new('color', '"orange"')
            ]),
        ]).inspect,
        parser.parse('(fruits
			  (fruit (@ (fresh true) (weight 5))
			    (name "apple")
			    (color "green")
			  )
			(fruit (@ (fresh false) (weight -10))
			    (name "orange")
			    (color "orange")
			  )
			)').inspect
    )
  end

end