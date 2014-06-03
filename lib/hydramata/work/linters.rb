shared_examples 'a presented entity' do |default_presented_entity_class|
  let(:presented_entity_class) { (default_presented_entity_class || described_class) }

  context 'its #each_fieldset_with_properties' do
    it 'takes a block' do
      expect(presented_entity_class.instance_method(:each_fieldset_with_properties).parameters.last[1]).to eq(:block)
    end
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
    let(:entity) { entity_class.new }
    its(:properties) { should be_a_kind_of(Enumerable) }
    its(:properties) { should respond_to(:<<) }
    its(:properties) { should respond_to(:[]) }
    its(:properties) { should respond_to(:each) }
    its(:properties) { should respond_to(:fetch) }
  end
end
