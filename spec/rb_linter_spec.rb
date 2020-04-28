require './lib/check_errors'

describe CheckErrors do
  test1 = CheckErrors.new('./lib/sample_code.rb')

  describe "#check_error_extra_new_line" do
    it "Adds Error object for Extra new line error" do
      test1.line = "  "
      test1.check_error_extra_new_line(10, 11)
      expect(test1.errors[11]).to eql(["Avoid extra line breaks"])
    end

    it " Dont add Error object for valid line" do
      test1.line = "puts 'hello'"
      test1.check_error_extra_new_line(10, 12)
      expect(test1.errors[12]).to eql(nil)
    end

    it " Set nl_index to index, if the line is empty and nl_index is -1" do
      test1.line = "  "
      expect(test1.check_error_extra_new_line(-1, 12)).to eql(12)
    end

    it " Set nl_index to -1, if the line is not empty and nl_index is -1" do
      test1.line = " asdf "
      expect(test1.check_error_extra_new_line(-1, 12)).to eql(-1)
    end
  end

  describe '#check_error_new_line_after_modifers(ac_index, index)' do
    it "Adds Error object for no new line after modifer" do
      test1.line = "  "
      test1.check_error_extra_new_line(10, 11)
      expect(test1.errors[11]).to eql(["Avoid extra line breaks"])
    end
  end

end
