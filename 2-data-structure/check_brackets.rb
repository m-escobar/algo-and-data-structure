def bracket_pair(pair)
  open = ['[','{','(']
  close = [']','}',')']

  open[close.index(pair)]
end


def check_brackets(input)
  close = [']','}',')']
  opening_brackets_stack = []
  opening_brackets_pos = []
  pos = nil

  for position in 0...(input.length) do
      next_char = input[position]

      if next_char == '(' || next_char == '[' || next_char == '{'
        opening_brackets_stack << next_char
        opening_brackets_pos << position + 1
      end

      if next_char == ')' || next_char == ']' || next_char == '}'
        if !opening_brackets_stack.last.nil? and opening_brackets_stack.last == bracket_pair(next_char)
          opening_brackets_stack.pop
          opening_brackets_pos.pop
        else
          opening_brackets_stack << next_char
          opening_brackets_pos << position + 1
        end
      end
  end

  if opening_brackets_stack.empty?
    result = 'Success'
  else
    close_pos = nil

    #check closing elements
    opening_brackets_stack.each do |stack|
      close_pos = close.index(stack)

      break unless close_pos.nil?
    end

    if close_pos.nil?
      result = opening_brackets_pos.last
    else
      elem_pos = opening_brackets_stack.index(close[close_pos])
      result = opening_brackets_pos[elem_pos]
    end
  end

  result
end

#main
input = gets.chomp

puts check_brackets(input)
