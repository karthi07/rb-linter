class LintErrors
  attr_reader :errors
  
  def initialize
    @errors = {}
  end

  def add_error(index, error_str)
    @errors[index] == nil ? @errors[index] = [error_str] : @errors[index].append(error_str)
  end

  def show_errors
    @errors.each do |index,error|
      puts "Line #{index + 1}: #{error.join(", ")}"
    end
  end

end