require_relative('code_errors')

class CodeFile < LintErrors
  attr_reader :lines

  def initialize(filepath)
    @lines = []
    @file = File.open(filepath) if File.extname(filepath) == '.rb'
    @lines = @file.readlines.map(&:chomp)
    super()
  end

  def print_lines
    print @lines
  end
end
