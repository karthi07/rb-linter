require_relative('code_file')

class CheckErrors < CodeFile
  attr_accessor :line

  def initialize(filepath)
    super(filepath)
    @line = ""
  end

  def check_error_new_line_after_modifers(ac_index, index)
    #check newline after access modifiers
    access_modifiers = ['public', 'private', 'protected', 'attr_accessor', 'attr_reader', 'attr_writer']
    access_modifiers.each do | ac |
      if @line.strip =~ /#{ac}/
        ac_index = index
      end
    end
    if ac_index != -1 && @line.strip != '' && (index == ac_index + 1)
      add_error(index,"Use empty lines around access modifiers")
      ac_index = -1
    end
    return ac_index
  end

  def check_error_extra_new_line(nl_index, index)
    puts "line : #{@line}"
    nl_index = index if @line.strip == '' && nl_index == -1
    if nl_index != -1 && index > nl_index
      @line.strip == '' ? add_error(index,'Avoid extra line breaks') : nl_index = -1
    end
    return nl_index
  end

  def check_error_space_after_exclaim(string_pos, index)

    #check no space after !
    exclam_indexs = @line.gsub(/!/).map { Regexp.last_match.begin(0)}
    exclam_indexs.each do | ex_index |
      exclam_index = ex_index if check_range(string_pos,ex_index)
      add_error(index,"No Space after Bang (!) at #{exclam_index+2}") if exclam_index && @line[exclam_index + 1] == ' '
    end
  end

  def check_error_space_for_braces(string_pos, index)
    #check no space after !
    braces_indexs = @line.gsub(/\(/).map { Regexp.last_match.begin(0)}
    braces_indexs += @line.gsub(/\[/).map { Regexp.last_match.begin(0)}
    braces_indexs.each do | ex_index |
      braces_index = ex_index if check_range(string_pos,ex_index)
      add_error(index,"No Space after opening braces at #{braces_index+2}") if braces_index && @line[braces_index + 1] == ' '
    end

    braces_indexs = @line.gsub(/\)/).map { Regexp.last_match.begin(0)}
    braces_indexs += @line.gsub(/\]/).map { Regexp.last_match.begin(0)}
    braces_indexs.each do | ex_index |
      braces_index = ex_index if check_range(string_pos,ex_index)
      add_error(index,"No Space before closing braces at #{braces_index-2}") if braces_index && @line[braces_index - 1] == ' '
    end

  end

  def check_error_hard_tab(string_pos, index)
    res = false
    tab_indexs =  @line.gsub(/\t/).map { Regexp.last_match.begin(0)}
    tab_indexs.each do | tab_index |
      if check_range(string_pos,tab_index)
        res = true
        break
      end
    end
    add_error(index,"Dont use tab for spacing (use spaces instead)") if res
  end

  def check_error_braces_order(string_pos, index)
    return nil if @line.strip == ''
    line = @line
    line = remove_strings_from_line(string_pos) if string_pos.length != 0
    stack = []
    # Traversing the Expression  
    i= 0
    #for char in expr
    error_text = nil
    while i < line.length
      char = line[i]
      if ['(', '{', '['].include? char
        # Push the element in the stack  
        stack.append(char) 
      elsif [')', '}', ']'].include? char
        if stack.length == 0
          error_text = "Paranthesis in the Expression is not balanced"
          break
        end
        current_char = stack.pop() 
        case
        when current_char == '('
          if char != ")"
            error_text = "Missing closing braces ')'"
            break
          end
        when current_char == '{'
          if char != '}'
            error_text = "Missing closing braces '}'"
            break
          end
        when current_char == '['
          if char != "]"
            error_text = "Missing closing braces ']'"
            break
          end
        end
      end
      i += 1
    end
    # Check Empty Stack 
    
    error_text = "Paranthesis in the Expression is not balanced" if stack.length != 0 && !error_text
    add_error(index, error_text) if error_text
  end


  def check_line_errors
    lines = @lines
    nl_index = -1
    ac_index = -1
    lines.each_with_index do |line,index|
      @line = line
      len = (@line).length
      add_error(index,"Statement should not end with ;") if @line.strip[-1] == ';'
      add_error(index,"Limit lines to 80 characters (use '/' to extend line)") if len >= 80
      
      #check trailing white spaces
      add_error(index,"Trailing white spaces") if (@line[-1] == ' ' || (@line[-1] == ' ' && @line.strip == ''))
      
      ac_index = check_error_new_line_after_modifers(ac_index,index)

      #check extra new @lines
      nl_index = check_error_extra_new_line(nl_index,index)

      # exclude string while checking
      string_pos = @line.gsub(/\"/).map { Regexp.last_match.begin(0)}
      string_pos += @line.gsub(/\'/).map { Regexp.last_match.begin(0)}
      
      check_error_space_after_exclaim(string_pos, index)

      check_error_hard_tab(string_pos, index)

      check_error_space_for_braces(string_pos, index)

      check_error_braces_order(string_pos,index)

    end
  end

  def remove_strings_from_line(string_pos)
    i = 0
    line = @line
    while i < string_pos.length do
      line = line.gsub(@line[string_pos[i]..string_pos[i+1]], "")
      i += 2
    end
    line
  end

  def check_range(string_pos, ind)
    return false unless ind
    res = true
    string_pos.each_with_index do |pos, index|
      if index % 2 == 1 && ind < pos
        res = false if ind > string_pos[index -1]
      end
    end
    res
  end
end
