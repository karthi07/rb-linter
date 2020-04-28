require 'colorize'

class LintErrors
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(index, type, error_str)
    @errors[index] == nil ? @errors[index] = [[type,error_str]] : @errors[index].append([type,error_str])
  end

  def show_errors
    @errors.each do |index,error|
      error.each do | er |
        puts "Line #{index + 1}:" + " warning : ".colorize(:light_yellow) +  " #{er[1]}" if er[0] == 0
        puts "Line #{index + 1}: Error   : #{er[1]}".colorize(:red) if er[0] == 1
      end
    end
  end

end