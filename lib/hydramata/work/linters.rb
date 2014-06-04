shared_examples 'a presented entity' do |default_presented_entity_class|
  let(:presented_entity_class) { (default_presented_entity_class || described_class) }
  it 'responds to #fieldsets' do
    expect { presented_entity_class.instance_method(:fieldsets) }.
    to_not raise_error
  end
end

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

shared_examples 'a work entity' do |entity_builder|
  let(:entity_class) { (entity_builder || described_class) }

  context 'its #initialize method' do
    it 'does not have a required first parameter' do
      expect(entity_class.instance_method(:initialize).parameters.first[0]).to eq(:opt)
    end
    it 'takes a block' do
      expect(entity_class.instance_method(:initialize).parameters.last[1]).to eq(:block)
    end
  end

  context 'its #properties method' do
    subject { entity_class.new.properties }
    it { should be_a_kind_of(Enumerable) }
    it { should respond_to(:<<) }
    it { should respond_to(:[]) }
    it { should respond_to(:each) }
    it { should respond_to(:fetch) }
  end
end
