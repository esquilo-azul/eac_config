# frozen_string_literal: true

require 'eac_config/envvars_node'
require 'eac_ruby_utils/ruby'

RSpec.describe ::EacConfig::EnvvarsNode do
  let(:instance) { described_class.new }

  before do
    ENV['COMMON'] = 'AAA'
    ENV['BLANK'] = ''
    ENV.delete('NO_EXIST')
  end

  context 'with common entry' do
    let(:entry) { instance.entry('common') }

    it { expect(entry).to be_a(::EacConfig::Entry) }
    it { expect(entry.value).to eq('AAA') }
    it { expect(entry.found_node).to eq(instance) }
    it { expect(entry).to be_found }

    context 'with a clean ruby environment' do
      let(:entry_value) do
        ::EacRubyUtils::Ruby.on_clean_environment do
          entry.value
        end
      end

      it { expect(entry_value).to eq('AAA') }
    end
  end

  context 'with blank entry' do
    let(:entry) { instance.entry('blank') }

    it { expect(entry).to be_a(::EacConfig::Entry) }
    it { expect(entry.value).to eq('') }
    it { expect(entry.found_node).to eq(instance) }
    it { expect(entry).to be_found }
  end

  context 'with not existing entry' do
    let(:entry) { instance.entry('no.exist') }

    it { expect(entry).to be_a(::EacConfig::Entry) }
    it { expect(entry.value).to eq(nil) }
    it { expect(entry.found_node).to eq(nil) }
    it { expect(entry).not_to be_found }
  end
end
