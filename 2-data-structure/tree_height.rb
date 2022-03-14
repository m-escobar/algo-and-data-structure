def tree_height(input)
  numbers = Hash.new
  groups = Hash.new

  input.split(' ').each_with_index{|n, idx| numbers[idx] = n.to_i}

  numbers.each do |k, v|
    groups[v].nil? ? groups[v] = [k] : groups[v] << k
  end

  keys = groups[-1]
  levels_count = 1

  loop do
    indexes = []

    keys.each do |k|
      indexes << groups[k] unless groups[k].nil?
    end

    indexes.flatten!
    break if indexes.empty?
    keys = indexes
    levels_count += 1
  end

  levels_count
end

#main
n = gets.chomp
input = gets.chomp

puts tree_height(input)
