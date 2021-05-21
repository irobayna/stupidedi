describe Stupidedi::Schema::ExternalCodeListStorage do
  describe '.empty' do
    subject(:storage) { described_class }

    it 'returns an empty code storage' do
      expect(storage.empty).to be_a(Stupidedi::Schema::ExternalCodeListStorage)
      expect(storage.empty).to be_empty
    end
  end

  let(:external_code_list_sample) do
    {
      'k1' => 'value 1',
      'k2' => 'value 2'
    }
  end

  describe '#register' do
    subject(:code_list_storage) { described_class.empty }

    it 'adds an external code list to the config' do
      expect {
        code_list_storage.register('EXT', external_code_list_sample)
      }.to change {
        code_list_storage.storage
      }.from({}).to({ 'EXT' => external_code_list_sample })
    end
  end

  describe '#fetch' do
    subject(:code_list_storage) { described_class.empty }

    before { code_list_storage.register('EXT', external_code_list_sample) }

    it 'fetches an external code list with given id' do
      expect(code_list_storage.fetch('EXT')).to eq(external_code_list_sample)
    end

    it 'returns an empty dictionary for missing code lists' do
      expect(code_list_storage.fetch('missing')).to eq({})
    end
  end
end
