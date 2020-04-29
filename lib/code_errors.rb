require 'colorize'

class LintErrors
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(index, type, error_str)
    if @errors[index].nil?
      @errors[index] = [[type, error_str]]
    else
      @errors[index].append([type, error_str])
    end
  end

  def show_errors
    puts 'No Errors Found. ' unless @error

    @errors.each do |index, error|
      error.each do |er|
        puts "Line #{index + 1}:" + ' warning : '.colorize(:light_yellow) + " #{er[1]}" if er[0].zero?
        puts "Line #{index + 1}: Error   : #{er[1]}".colorize(:red) if er[0] == 1
      end
    end
  end
end
