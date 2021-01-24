class Element
  @absolute

  def search(string)
    @absolute = string[0] == '/'[0]
    queue = []
    root = make_bi_tree(nil, self)
    esa = extract_search_atoms(string)
    queue.push(root)
    until queue.empty?
      current = queue.shift
      #compare
      result = compare_nodes(current, esa)
      #print results
      if result
        print_hash(current)
=begin
        path = ""
        curr = current
        begin
          path.insert(0, '/'+curr[:key])
          curr = curr[:parent]
        end while curr != nil
        puts path
=end
      end
      #add children to queue
      if current[:children]
        current[:children].each { |x| queue.push(x) }
      end
    end
  end

  def print_hash(hash, depth = 0)
    if hash == nil
      puts '()'
      return
    end
    str_pad = ' ' * depth
    if hash[:value] == nil
      print str_pad + '('
      print hash[:key]
      puts ' => '
      if hash[:params] != nil
        puts ' ' * (depth + 2) + '(@ =>'
        hash[:params].each { |x| print_hash(x, depth + 4) }
        puts ' ' * (depth + 2) + ')'
      end
      if hash[:children] != nil
        hash[:children].each { |x| print_hash(x, depth + 2) }
      end
      puts str_pad + ')'
    else
      puts str_pad + '(' + (hash[:key] + ' => ') + hash[:value].to_s + ')'
    end
  end

  def compare_nodes(node, esa, index = 0)
    #check if we got end of matching string
    if index >= esa.length
      if @absolute and node[:parent] != nil
        return false
      else
        return true
      end
    end

    #joker check
    if esa[esa.length - 1 - index][:key] == '*'
      current = node
      result = [false]
      while current[:parent] != nil
        result << compare_nodes(current[:parent], esa, index + 1)
        current = current[:parent]
      end
      if current[:parent] == nil and index == esa.length - 1
        return true
      end
      return result.any?
    else
      #base check
      if esa[esa.length - 1 - index][:key] != node[:key]
        return false
      end
    end

    #params check
    if esa[esa.length - 1 - index][:params] != nil
      esa[esa.length - 1 - index][:params].each { |x|
        key = x[:key]
        value = x[:value]
        if value == nil
          if node[:value] != key
            return false
          end
        else
          if node[:params] == nil
            return false
          end
          found = false
          node[:params].each { |y|
            if y[:key] == key
              if y[:value].to_s == value
                found = true
              end
            end
          }
          unless found
            return false
          end
        end
      }
    end

    #check if we got top of tree
    if node[:parent] != nil
      compare_nodes(node[:parent], esa, index + 1)
    else
      if index == esa.length - 1
        return true
      else
        return false
      end
    end

    true
  end

  def make_bi_tree(parent, element)
    params = element.get_params
    if params
      params = params.map { |ele|
        param = {:key => ele.get_key.to_s, :value => ele.get_data}
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
      children = children.map { |x| make_bi_tree(data, x) }
    end
    data[:children] = children

    data
  end

  def extract_search_atoms (string)
    string_literals = []
    string.gsub(/[\w\[=\]*"]+/) { |x| string_literals << x }
    string_literals.map { |str|
      tok = str.match(/(\w+|\*)/)
      tok = tok.to_a
      _, key = tok
      tok = str.scan(/\[(\w+)=(\w+)\]/)
      params = tok.map { |t|
        paramkey, paramvalue = t
        param = {:key => paramkey, :value => paramvalue}
        param
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
      result.get_data
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

end