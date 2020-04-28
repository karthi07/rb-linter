#!/usr/bin/env ruby

require('./lib/check_errors')

def run_linter(filepath)
  puts "\n \n   Ruby Linter Results for #{filepath} \n \n"
  errors = CheckErrors.new(filepath)
  errors.check_line_errors
  errors.show_errors
end

ARGV.each do |arg|
  if File.extname(arg) == '.rb'
    run_linter(arg)
  else
    puts "\n \n#{arg} is not a valid ruby file. Please provide valid filename/path \n"
  end
end
