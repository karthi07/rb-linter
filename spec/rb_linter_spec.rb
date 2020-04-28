require './lib/check_errors'

describe CheckErrors do
  test1 = CheckErrors.new('./lib/sample_code.rb')
  let(:empty_line) { ' ' }
  let(:text_line) { "puts 'hello world'" }

  describe '#check_error_extra_new_line' do
    it 'Adds Error object for Extra new line error' do
      test1.line = empty_line
      test1.check_error_extra_new_line(10, 11)
      expect(test1.errors[11]).to include('Avoid extra line breaks')
    end

    it ' Dont add Error object for valid line' do
      test1.line = text_line
      nl_index = 10
      index = 12
      test1.check_error_extra_new_line(nl_index, index)
      expect(test1.errors[12]).to eql(nil)
    end

    it ' Set nl_index to index, if the line is empty and nl_index is -1' do
      test1.line = empty_line
      nl_index = -1
      index = 8
      expect(test1.check_error_extra_new_line(nl_index, index)).to eql(8)
    end

    it ' Set nl_index to -1, if the line is not empty and nl_index is -1' do
      test1.line = text_line
      nl_index = -1
      index = 6
      expect(test1.check_error_extra_new_line(nl_index, index)).to eql(-1)
    end
  end

  describe '#check_error_new_line_after_modifers(ac_index, index)' do
    it 'Adds Error object for no new line after access modifer' do
      test1.line = text_line
      ac_index = 14
      index = 15
      string_pos = []
      test1.check_error_new_line_after_modifers(string_pos, ac_index, index)
      expect(test1.errors[14]).to include('Use empty lines after access modifiers')
    end

    it 'Shoudnot add Error object for new line after access modifer' do
      test1.line = empty_line
      ac_index = 16
      index = 17
      string_pos = []
      test1.check_error_new_line_after_modifers(string_pos, ac_index, index)
      expect(test1.errors[16]).to eql(nil)
    end

    it 'Shoudnot add Error object for access modifer within string' do
      test1.line = "puts 'public world'"
      ac_index = 18
      index = 19
      string_pos = [6, 20]
      ac_index = test1.check_error_new_line_after_modifers(string_pos, ac_index, index)
      expect(ac_index).to eql(-1)
    end
  end

  describe '#check_error_space_after_exclaim(string_pos, index)' do
    it 'Adds Error object for space after Exclaim (!)' do
      test1.line = '! hello'
      index = 25
      string_pos = []
      test1.check_error_space_after_exclaim(string_pos, index)
      expect(test1.errors[25]).to include('No Space after Bang (!) at 2')
    end
    it "Should'nt Error object for space after Exclaim (!)" do
      test1.line = '!hello'
      index = 28
      string_pos = []
      test1.check_error_space_after_exclaim(string_pos, index)
      expect(test1.errors[28]).to eql(nil)
    end
  end

  describe '#check_error_space_for_braces(string_pos, index)' do
    it 'Adds Error object for No spaces after, before Braces' do
      test1.line = 'func( helo)'
      index = 30
      string_pos = []
      test1.check_error_space_for_braces(string_pos, index)
      expect(test1.errors[30]).to include('No Space after opening braces at 6')
    end
    it 'Adds Error object for No spaces after, before Braces' do
      test1.line = 'func(helo )'
      index = 30
      string_pos = []
      test1.check_error_space_for_braces(string_pos, index)
      expect(test1.errors[30]).to include('No Space before closing braces at 9')
    end
  end

  describe '#check_error_braces_order(string_pos, index)' do
    it 'Adds Error object for Unbalanced Paranthesis Expression' do
      test1.line = 'func( helo'
      index = 32
      string_pos = []
      test1.check_error_braces_order(string_pos, index)
      expect(test1.errors[32]).to include('Paranthesis in the Expression is not balanced')
    end
    it 'Adds Error object for Unbalanced Paranthesis Expression' do
      test1.line = 'func(helo{)'
      index = 33
      string_pos = []
      test1.check_error_braces_order(string_pos, index)
      expect(test1.errors[33]).to include("Missing closing braces '}'")
    end
    it "Should'nt add Error object for balanced Paranthesis Expression" do
      test1.line = 'func(helo{})'
      index = 34
      string_pos = []
      test1.check_error_braces_order(string_pos, index)
      expect(test1.errors[34]).to eql(nil)
    end
  end
end
