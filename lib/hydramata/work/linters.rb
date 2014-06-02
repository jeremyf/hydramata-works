shared_examples 'a datastream parser' do |default_parser|
  let(:datastream_parser) { default_parser || described_class }
  it 'responds to #call' do
    expect(datastream_parser).to respond_to(:call)
  end

  context 'its #call method' do
    it 'has a required first parameter' do
      expect(datastream_parser.method(:call).parameters.first[0]).to eq(:req)
    end
    it 'takes a block' do
      expect(datastream_parser.method(:call).parameters.last[1]).to eq(:block)
    end
  end
end
