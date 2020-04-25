require_relative('code_file')

class CheckErrors < CodeFile

  def initialize(filepath)
    super(filepath)
    @errors = {}
  end

  def check_line_errors
    lines = @lines
    nl_index = -1
    lines.each_with_index do |line,index|
      len = (line).length
      add_error(index,"Statement should not end with ;") if line.strip[-1] == ';'
      add_error(index,"Limit lines to 80 characters. ") if len >= 80
      add_error(index,"Trailing white spaces ") if (line[-1] == ' ' || (line[-1] == ' ' && line.strip == ''))
      #check extra new lines
      
      nl_index = index if line.strip == '' && nl_index == -1
      if nl_index != -1 && index > nl_index
        line.strip == '' ? add_error(index,"Extra line breaks") : nl_index = -1
      end
      s = StringScanner.new(line)
      add_error(index,"Dont ues hard tab (use spaces instead)") if s.exist? /\t/

    end
  end

  def check_extra_empty_line(lines)
    nl_index = -1
    lines.each_with_index do |line,index|
      # to improve strip only if [ line contains spaces alone ]
      line = line.strip
      nl_index = index if line == '' && nl_index == -1
      if nl_index != -1 && index > nl_index
        line == '' ? print("extra line breaks at #{index+1}\n") : nl_index = -1
      end
    end
  end

  def add_error(index, error_str)
    @errors[index] == nil ? @errors[index] = [error_str] : @errors[index].append(error_str)
  end

  def show_errors
    @errors.each do |index,error|
      puts "Line #{index + 1}: #{error}"
    end
  end
end

#code1 = CodeFile.new()
errors = CheckErrors.new('sample_code.rb')
errors.check_line_errors()
errors.show_errors