# frozen_string_literal: true

require 'eac_config/manager'
require 'eac_config/yaml_file_node'

RSpec.describe ::EacConfig::Manager do
  let(:fixtures_dir) { ::Pathname.new(__dir__).join('manager_spec_files') }
  let(:yaml_file_path) { fixtures_dir.join('storage1.yaml') }
  let(:root_node) { ::EacConfig::YamlFileNode.new(yaml_file_path) }
  let(:instance) { described_class.new(root_node) }

  context 'with common entry' do
    let(:entry) { instance.entry('common') }

    it { expect(entry.value).to eq('AAA') }
    it { expect(entry.source_node).to eq(root_node) }
    it { expect(entry).to be_found }
  end

  context 'with not existing entry' do
    let(:entry) { instance.entry('no_exist') }

    it { expect(entry.value).to eq(nil) }
    it { expect(entry.source_node).to eq(nil) }
    it { expect(entry).not_to be_found }
  end
end
