require_relative 'parser.rb'
require_relative 'schema.rb'
require_relative 'search.rb'
require_relative 'html_element.rb'

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
query = '/fruits/fruit/name["orange"]'
puts "For query #{query} found:"
example1.search(query)
puts "--"

query = 'fruit[weight=5]/name'
puts "For query #{query} found:"
example1.search(query)
puts '-' * 10

# Schema example
example1 = parser.parse('(fruits (@ (fresh true)) "hello")')
schema1 = parser.parse('(element (& (name fruits) (type string)))')

schema = Schema.new(schema1)
puts 'Schema validation example: ', schema.validate(example1)

puts '-' * 10

# Html example
puts "Html example:"
puts parser.parse('(fruits
			  (fruit (@ (fresh true) (weight 5))
			    (name "apple")
			    (color "green")
			  )
			(fruit (@ (fresh false) (weight -10))
			    (name "orange")
			    (color "orange")
			  )
			)').to_html