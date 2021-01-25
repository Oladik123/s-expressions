require 'test/unit'
require_relative '../src/html_element'
require_relative '../src/parser'

class HtmlTest < Test::Unit::TestCase
  def test_single_tag
    assert_equal("<fruit/>\n", Parser.new.parse('(fruit)').to_html)
  end

  def test_single_tag_with_attrs
    assert_equal("<fruit weight=\"100\"/>\n", Parser.new.parse('(fruit (@ (weight 100)))').to_html)
  end

  def test_tag_with_children
    assert_equal(
        "<fruit fresh=\"true\" weight=\"5\">\n" <<
            "  <name>\n" <<
            "    \"apple\"\n" <<
            "  </name>\n" <<
            "  <color>\n" <<
            "    \"green\"\n" <<
            "  </color>\n" <<
            "</fruit>",
        Parser.new.parse(
            '(fruit (@ (fresh true) (weight 5))
			                  (name "apple")
			                  (color "green")
			                )'

        ).to_html
    )
  end
end