# frozen_string_literal: true

require 'tempfile'
require 'eac_config/old_configs'

RSpec.describe EacConfig::OldConfigs do
  let(:configs_key) { 'configsspec' }
  let(:storage_path) do
    file = Tempfile.new(configs_key)
    path = file.path
    file.close
    file.unlink
    path
  end
  let(:instance) { described_class.new(configs_key, storage_path: storage_path) }

  describe '#storage_path' do
    it { expect(instance.storage_path).to eq(storage_path) }
  end

  describe '#write' do
    let(:entry_key) { 'parent.child' }

    before do
      instance[entry_key] = 'value1'
      instance.save
    end

    it { expect(YAML.load_file(storage_path)).to eq(parent: { child: 'value1' }) }
  end

  describe '#read' do
    let(:present_key) { 'a.present.key' }
    let(:blank_key) { 'a.blank.key' }

    before do
      instance[present_key] = 'A value'
      instance[blank_key] = ''
      instance.save
      instance.load
    end

    it { expect(instance[present_key]).to be_present }
    it { expect(instance[blank_key]).to be_present }
  end
end
