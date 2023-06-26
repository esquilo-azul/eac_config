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

  describe '#entries' do
    context 'when search path is "common"' do
      let(:path) { 'common' }
      let(:actual) { instance.entries(path).node_entries }
      let(:expected) { [::EacConfig::YamlFileNode::Entry.new(storage1, path)] }

      it { expect(actual).to eq(expected) }
    end

    context 'when search path is "same.path"' do
      let(:path) { 'same.path' }
      let(:actual) { instance.entries(path).node_entries }
      let(:expected) do
        [storage1_1, storage1_2_1].map do |n|
          ::EacConfig::YamlFileNode::Entry.new(n, 'same.path')
        end
      end

      it { expect(actual).to eq(expected) }
    end

    context 'when search path is "*.search_me"' do
      let(:path) { '*.search_me' }
      let(:actual) { instance.entries(path).node_entries }
      let(:expected) do
        [
          [storage1, 'storage1_a'], [storage1, 'storage1_b'],
          [storage1_2, 'storage1_2_a'], [storage1_2, 'storage1_2_b'], [storage1_2, 'storage1_2_c']
        ].map do |args|
          ::EacConfig::YamlFileNode::Entry.new(args[0], args[1] + '.search_me')
        end
      end

      it { expect(actual).to eq(expected) }
    end
  end
end
