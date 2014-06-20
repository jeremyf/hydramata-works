shared_examples 'a presented entity' do |default_presented_entity_class|
  let(:presented_entity_class) { (default_presented_entity_class || described_class) }
  it 'responds to #fieldsets' do
    expect { presented_entity_class.instance_method(:fieldsets) }.
    to_not raise_error
  end
end

shared_examples 'a datastream parser' do |default_parser|
  let(:parser) { default_parser || described_class }
  it 'responds to .call' do
    expect(parser).to respond_to(:call)
  end

  it 'responds to .match?' do
    expect(parser).to respond_to(:match?)
  end

  context 'its .call method' do
    it 'has a required first parameter' do
      expect(parser.method(:call).parameters.first[0]).to eq(:req)
    end
    it 'takes a block' do
      expect(parser.method(:call).parameters.last[1]).to eq(:block)
    end
  end
end

shared_examples 'a predicate parser' do |default_parser|
  let(:parser) { default_parser || described_class }
  it 'responds to #call' do
    expect(parser).to respond_to(:call)
  end

  context 'its #call method' do
    it 'has a required first parameter' do
      expect(parser.method(:call).parameters.first[0]).to eq(:req)
    end
    it 'takes a block' do
      expect(parser.method(:call).parameters.last[1]).to eq(:block)
    end
  end
end

shared_examples 'a value parser' do |default_parser|
  let(:parser) { default_parser || described_class }
  it 'responds to #call' do
    expect(parser).to respond_to(:call)
  end

  context 'its #call method' do
    it 'has a required first parameter' do
      expect(parser.method(:call).parameters.first[0]).to eq(:req)
    end
    it 'takes a block' do
      expect(parser.method(:call).parameters.last[1]).to eq(:block)
    end
  end
end
