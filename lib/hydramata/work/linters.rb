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

shared_examples_for 'ActiveModel' do
  # From the ActiveModel::Lint::Test model
  it 'implements #to_key' do
    expect(subject).to respond_to(:to_key)
    def subject.persisted?() false end
    expect(subject.to_key).to be_nil
  end

  it 'implements #to_param' do
    expect(subject).to respond_to(:to_param)
    def subject.to_key() [1] end
    def subject.persisted?() false end
    expect(subject.to_param).to be_nil
  end

  it 'implements #to_partial_path' do
    expect(subject).to respond_to(:to_partial_path)
    expect(subject.to_partial_path).to be_a_kind_of(String)
  end

  it 'implements #persisted?' do
    expect(subject).to respond_to(:persisted?)
    expect([true, false]).to include(subject.persisted?)
  end

  it 'implements .model_naming' do
    expect(subject.class).to respond_to(:model_name)
    model_name = subject.class.model_name
    expect(model_name).to respond_to(:to_str)
    expect(model_name.human).to respond_to(:to_str)
    expect(model_name.singular).to respond_to(:to_str)
    expect(model_name.plural).to respond_to(:to_str)
  end

  it 'implements #errors' do
    expect(subject).to respond_to(:errors)
    expect(subject.errors[:hello]).to be_an_instance_of(Array)
  end
end
