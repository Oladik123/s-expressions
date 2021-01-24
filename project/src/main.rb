require_relative 'parser.rb'
require_relative 'schema.rb'
require_relative 'search.rb'

parser = Parser.new

example1 = parser.parse('(fruits
  (fruit (@ (fresh true) (weight 5))
    (name "apple")
    (color "green")
  )
(fruit (@ (fresh false) (weight 2))
    (name "orange")
    (color "orange")
  )
)')

# Parser example
puts 'Parser example: ', example1.inspect
puts '-' * 10

# Convert to s-expression example
puts 'Convert to s-expression example:'
example1.convert_to_s_expression
puts '-' * 10

# Search example
puts 'Search example:'
example1.search('/fruits/fruit/name["orange"]')
puts '-' * 10

# Schema example
example1 = parser.parse('(fruits (@ (fresh true)) "hello")')
schema1 = parser.parse('(element (& (name fruits) (type string)))')

schema = Schema.new(schema1)
puts 'Schema validation example: ', schema.validate(example1)