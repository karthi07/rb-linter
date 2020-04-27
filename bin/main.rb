#!/usr/bin/env ruby

require('./lib/check_errors')

errors = CheckErrors.new('./lib/sample_code.rb')
errors.check_line_errors
errors.show_errors