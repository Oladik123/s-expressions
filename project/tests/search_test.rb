require 'test/unit'
require_relative '../src/element'
require_relative '../src/search'
require_relative '../src/parser'


class SearchTest < Test::Unit::TestCase

  def test_compare_basic
    parser = Parser.new
    example1 = parser.parse('(fruits "hello")')
    node = {
        :parent => nil,
        :key => 'testkey',
        :value => nil,
        :params => nil,
        :childs => nil
    }
    se = {:key => 'testkey',
          :params => nil}
    esa = [se]
    assert_equal(true, example1.compare_nodes(node, esa))
  end

  def test_compare_advanced
    parser = Parser.new
    example1 = parser.parse('(fruits "hello")')
    root = example1.make_tree(nil, example1)
    esa = Element.extract_search_atoms('/fruits')
    assert_true(example1.compare_nodes(root, esa))

    esa = Element.extract_search_atoms('/fruits["hello"]')
    assert_true(example1.compare_nodes(root, esa))

    esa = Element.extract_search_atoms('/*')
    assert_true(example1.compare_nodes(root, esa))

    esa = Element.extract_search_atoms('*')
    assert_true(example1.compare_nodes(root, esa))

    esa = Element.extract_search_atoms('fruits')
    assert_true(example1.compare_nodes(root, esa))
  end

  def test_compare_params
    parser = Parser.new
    example_5 = parser.parse("(fruit (@ (weight 5))")
    example_1 = parser.parse("(fruit (@ (weight 1))")
    root_5 = example_5.make_tree(nil, example_5)
    root_1 = example_1.make_tree(nil, example_1)

    esa_5 = Element.extract_search_atoms('fruit[weight=5]')
    esa_1 = Element.extract_search_atoms('fruit[weight=1]')
    esa_raw = Element.extract_search_atoms('fruit')

    assert_true(example_5.compare_nodes(root_5, esa_5))
    assert_false(example_1.compare_nodes(root_1, esa_5))

    assert_true(example_1.compare_nodes(root_1, esa_1))
    assert_false(example_5.compare_nodes(root_5, esa_1))

    assert_true(example_1.compare_nodes(root_1, esa_raw))
    assert_true(example_5.compare_nodes(root_5, esa_raw))

  end

end