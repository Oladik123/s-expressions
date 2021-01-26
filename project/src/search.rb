class Element
  @absolute

  # Prints node found by query
  # @param string search query
  def search(string)
    @absolute = string[0] == '/'[0]
    queue = []
    root = make_tree(nil, self)
    esa = Element.extract_search_atoms(string)
    queue.push(root)
    until queue.empty?
      current = queue.shift
      #compare
      result = compare_nodes(current, esa)
      #print results
      print_hash(current) if result

      #add children to queue
      if current[:children]
        current[:children].each { |x| queue.push(x) }
      end
    end
  end

  # Prints node pretty
  def print_hash(node, depth = 0)
    if node == nil
      puts '()'
      return
    end
    str_pad = ' ' * depth
    if node[:value] == nil
      print str_pad + '('
      print node[:key]
      puts ' => '
      if node[:params] != nil
        puts ' ' * (depth + 2) + '(@ =>'
        node[:params].each { |x| print_node(x, depth + 4) }
        puts ' ' * (depth + 2) + ')'
      end
      if node[:children] != nil
        node[:children].each { |x| print_node(x, depth + 2) }
      end
      puts str_pad + ')'
    else
      puts str_pad + '(' + (node[:key] + ' => ') + node[:value].to_s + ')'
    end
  end

  # @param node
  # @return true if node matches search query
  def compare_nodes(node, esa, index = 0)
    #check if we got end of matching string
    if index >= esa.length
      return end_check(node, esa)
    end

    #wildcard check
    if esa[- 1 - index][:key] == '*'
      return wildcard_check(node, esa, index)
    end

    #base check
    if esa[- 1 - index][:key] != node[:key]
      return false
    end

    #params check
    if esa[- 1 - index][:params] != nil
      return false unless params_matched(node, esa, index)
    end

    # upper
    if node[:parent] != nil
      return compare_nodes(node[:parent], esa, index + 1)
    end

    # check root reached
    if index == esa.length - 1
      return true
    else
      return false
    end
  end

  # Builds tree to search through
  # @param parent should be nil for root element
  def make_tree(parent, element)
    params = element.get_params
    if params
      params = params.map { |elem|
        param = {:key => elem.get_key.to_s, :value => elem.get_data}
        param
      }
    end

    children = element.get_children
    value = element.get_value1
    data = {
        :parent => parent,
        :key => element.get_key.to_s,
        :value => value,
        :params => params,
        :children => nil
    }
    if children
      children = children.map { |x| make_tree(data, x) }
    end
    data[:children] = children
    data
  end

  # Splits query string to search atoms
  # @param string search query
  def self.extract_search_atoms (string)
    string_literals = []
    string.gsub(/[\w\[=\]*"]+/) { |x| string_literals << x }
    string_literals.map { |str|
      key = str.match(/(\w+|\*)/)[0]
      tok = str.scan(/\[(\w+)=(\w+)\]/)
      params = tok.map { |t|
        paramkey, paramvalue = t
        {:key => paramkey, :value => paramvalue}
      }
      tok = str.scan(/\[("\w+")\]/)
      unless tok.empty?
        param = {:key => tok[0][0], :value => nil}
        params << param
      end
      {
          :key => key,
          :params => params
      }
    }
  end

  # Get node attributes (@)
  # @return array of kv-attributes
  def get_params
    result = @data
    if result.kind_of?(Array)
      result = result.find_all { |x|
        x.get_key == '@'.to_sym
      }.first
      if result
        result.get_data
      end
    elsif result.kind_of?(Element)
      return nil if (result.get_key != '@'.to_sym)
      [result.get_data]
    else
      nil
    end
  end

  def get_children
    result = @data
    if result.kind_of?(Array)
      result.find_all { |x|
        x.get_key != '@'.to_sym
      }
    elsif result.kind_of?(Element)
      return nil if (result.get_key == '@'.to_sym)
      result.get_data
    else
      nil
    end
  end


  def get_value1
    result = @data
    if result.kind_of?(Array)
      result.find_all { |x|
        x.kind_of?(String)
      }.first
    elsif result.kind_of?(String)
      result
    else
      nil
    end
  end

  def get_data
    @data
  end

  private

  def params_matched(node, esa, index)
    matched = true
    esa[-1 - index][:params].each { |x|
      key = x[:key]
      value = x[:value]
      if value == nil
        if node[:value] != key
          matched = false
          break
        end
      elsif node[:params] == nil
        matched = false
        break
      else
        found = false
        node[:params].each { |y|
          if y[:key] == key
            if y[:value].to_s == value
              found = true
            end
          end
        }
        unless found
          matched = false
          break
        end
      end
    }
    matched
  end

  def wildcard_check(node, esa, index)
    current = node
    result = [false]
    while current[:parent] != nil
      result << compare_nodes(current[:parent], esa, index + 1)
      current = current[:parent]
    end
    if current[:parent] == nil and index == esa.length - 1
      return true
    end
    result.any?
  end

  def end_check(node, esa)
    if @absolute and node[:parent] != nil
      false
    else
      true
    end
  end

end