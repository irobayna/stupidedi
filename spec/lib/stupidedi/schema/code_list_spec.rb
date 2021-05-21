describe Stupidedi::Schema::CodeList::Internal do
  let(:sample_list) do
    {
      "K1" => 'value 1',
      "K2" => 'value 2',
      "K3" => 'value 3'
    }
  end

  subject(:code_list) { described_class.new(sample_list) }

  describe '#codes' do
    it 'returns a list of codes' do
      expect(code_list.codes).to match_array(["K1", "K2", "K3"])
    end
  end

  describe '#external?' do
    it 'is false' do
      expect(code_list.external?).to eq(false)
    end
  end

  describe '#at' do
    it 'returns matching value' do
      expect(code_list.at('K1')).to eq('value 1')
      expect(code_list.at('K2')).to eq('value 2')
      expect(code_list.at('K3')).to eq('value 3')

      expect(code_list.at('missing')).to eq(nil)
    end
  end

  describe '#defined_at?' do
    it 'checks whether a code is defined' do
      expect(code_list.defined_at?('K1')).to eq(true)
      expect(code_list.defined_at?('K2')).to eq(true)
      expect(code_list.defined_at?('K3')).to eq(true)

      expect(code_list.defined_at?('missing')).to eq(false)
    end
  end
end


describe Stupidedi::Schema::CodeList::External do
  subject(:code_list) { described_class.new('id') }

  let(:sample_list) do
    {
      "EK1" => 'external value 1',
      "EK2" => 'external value 2',
      "EK3" => 'external value 3'
    }
  end

  describe '#external?' do
    it 'returns true' do
      expect(code_list.external?).to eq(true)
    end
  end

  describe '#codes' do
    subject(:code_list) { described_class.new('EXT') }

    before { Stupidedi.external_code_lists.register('EXT', sample_list) }

    it 'returns a list of codes' do
      expect(code_list.codes).to match_array(["EK1", "EK2", "EK3"])
    end
  end

  describe '#code_dictionary' do
  end

  describe "to_str" do
    it 'return string representation of a code list' do
      expect(code_list.to_str).to eq("CodeList.external(id)")
    end
  end
end

describe Stupidedi::Schema::CodeList do
  subject(:code_list) { described_class }

  describe '.build' do
    it 'builds an internal code list' do
      expect(code_list.build({})).to be_a(Stupidedi::Schema::CodeList::Internal)
    end
  end

  describe '.internal' do
    it 'builds an internal code list' do
      expect(code_list.internal({})).to be_a(Stupidedi::Schema::CodeList::Internal)
    end
  end

  describe '.external' do
    it 'builds an external code list' do
      expect(code_list.external('id')).to be_a(Stupidedi::Schema::CodeList::External)
    end
  end
end
