require_relative('code_file')

class CheckErrors < CodeFile

  def initialize(filepath)
    super(filepath)
  end

  def check_line_errors
    lines = @lines
    nl_index = -1
    ac_index = -1
    lines.each_with_index do |line,index|
      len = (line).length
      add_error(index,"Statement should not end with ;") if line.strip[-1] == ';'
      add_error(index,"Limit lines to 80 characters (use '/' to extend line)") if len >= 80
      
      #check no space before !
      exclam_index = line =~ /!/
      add_error(index,"No Space after Bang (!)") if exclam_index && line[exclam_index + 1] == ' '

      #check trailing white spaces
      add_error(index,"Trailing white spaces") \
      if (line[-1] == ' ' || (line[-1] == ' ' && line.strip == ''))
      
      #check newline after access modifiers
      access_modifiers = ['public', 'private', 'protected', 'attr_accessor', 'attr_reader', 'attr_writer']
      access_modifiers.each do | ac |
        if line.strip =~ /#{ac}/
          ac_index = index
        end
      end
      if ac_index != -1 && line.strip != '' && (index == ac_index + 1)
        add_error(index,"Use empty lines around access modifiers")
        ac_index = -1
      end


      #check extra new lines
      nl_index = index if line.strip == '' && nl_index == -1
      if nl_index != -1 && index > nl_index
        line.strip == '' ? add_error(index,"Avoid extra line breaks") : nl_index = -1
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

end

#code1 = CodeFile.new()
errors = CheckErrors.new('sample_code.rb')
errors.check_line_errors
errors.show_errors