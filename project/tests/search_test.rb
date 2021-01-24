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
    root = example1.make_bi_tree(nil, example1)
    esa = example1.extract_search_atoms('/fruits')
    assert_equal(true, example1.compare_nodes(root, esa))

    esa = example1.extract_search_atoms('/fruits["hello"]')
    assert_equal(true, example1.compare_nodes(root, esa))

    esa = example1.extract_search_atoms('/*')
    assert_equal(true, example1.compare_nodes(root, esa))

    esa = example1.extract_search_atoms('fruits')
    assert_equal(true, example1.compare_nodes(root, esa))
  end

end