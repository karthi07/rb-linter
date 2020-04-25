require 'strscan'
require 'os'

class CodeFile
  attr_reader :lines

  def initialize(filepath)
    @lines = []
    @file = File.open(filepath) if File.extname(filepath) == '.rb'
    @lines = @file.readlines.map(&:chomp)
    #File.foreach(filepath) { |line| @lines.append(line.split) } 
  end

  def print_lines
    # @lines.each {|line| puts line }
    print @lines
  end

  def get_file_encoding
    file_path = 'sample2.py'
    charset = if OS.mac?
      `file -I #{file_path}`.strip.split('charset=').last
    elsif OS.linux?
      `file -i #{file_path}`.strip.split('charset=').last
    else
      nil
    end
  end

  def scanner
    @lines.each do |line|
      s = StringScanner.new(line)
      puts s.scan(/\w+/)
    end
  end
end

code1 = CodeFile.new('sample_code.rb')
#p code1.get_file_encoding # need  to cheeck the charset types