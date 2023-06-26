# frozen_string_literal: true

require 'eac_ruby_utils/struct'
require 'eac_config/yaml_file_node'

RSpec.describe ::EacConfig::YamlFileNode do
  storages = %w[1 1_1 1_2 1_2_1].map do |suffix|
    key = "storage#{suffix}"
    subpath = "#{key}.yaml"
    subpath = "storage1_2/#{subpath}" if suffix == '1_2_1'
    ::EacRubyUtils::Struct.new(suffix: suffix, key: key, subpath: subpath.to_pathname)
  end

  let(:fixtures_dir) { ::Pathname.new(__dir__).join('yaml_file_node_spec_files') }
  let(:instance) { storage1 }

  storages.each do |storage|
    let(storage.key) { described_class.new(fixtures_dir.join(storage.subpath)) }
  end

  describe '#entry' do
    context 'with common entry' do
      let(:entry) { instance.entry('common') }

      it { expect(entry.value).to eq('AAA') }
      it { expect(entry.found_node).to eq(instance) }
      it { expect(entry).to be_found }
    end

    storages.each do |storage|
      context "with entry in loaded path \"#{storage.subpath}\"" do
        let(:entry) { instance.entry(storage.key) }
        let(:storage_node) { send(storage.key) }

        it { expect(entry).to be_a(::EacConfig::Entry) }
        it { expect(entry).to be_found }
        it { expect(entry.value).to eq(storage.key) }
        it { expect(entry.found_node.url).to eq(storage_node.url) }
      end
    end

    context 'with not existing entry' do
      let(:entry) { instance.entry('no_exist') }

      it { expect(entry).to be_a(::EacConfig::Entry) }
      it { expect(entry.value).to eq(nil) }
      it { expect(entry.found_node).to eq(nil) }
      it { expect(entry).not_to be_found }
    end
  end
end
