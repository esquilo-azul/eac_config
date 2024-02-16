# frozen_string_literal: true

require 'eac_config/paths_hash'

RSpec.describe ::EacConfig::PathsHash do
  let(:source_hash) do
    {
      parent: {
        child1: {
          child1_1: 'v1_1', # rubocop:disable Naming/VariableNumber
          child1_2: 'v1_2' # rubocop:disable Naming/VariableNumber
        },
        child2: 'v2'
      }
    }
  end
  let(:instance) { described_class.new(source_hash) }

  describe '#[]' do
    {
      'parent.child1.child1_1' => 'v1_1',
      'parent.child1.child1_2' => 'v1_2',
      'parent.child2' => 'v2',
      'no_exist' => nil,
      'parent.child1' => {
        child1_1: 'v1_1', # rubocop:disable Naming/VariableNumber
        child1_2: 'v1_2' # rubocop:disable Naming/VariableNumber
      }
    }.each do |entry_key, expected_value|
      it { expect(instance[entry_key]).to eq(expected_value) }
    end

    ['.only_suffix', '', '.', 'only_prefx.', 'empty..part'].each do |entry_key|
      it "invalid entry key \"#{entry_key}\" raises EntryKeyError" do
        expect { instance[entry_key] }.to raise_error(::EacConfig::PathsHash::EntryKeyError)
      end
    end
  end

  describe '#[]=' do
    let(:source_hash) { {} }

    before do
      instance['a.b.c'] = '123'
    end

    it { expect(instance.to_h).to eq(a: { b: { c: '123' } }) }
  end

  describe '#key?' do
    {
      'parent.child1.child1_1' => true,
      'parent.child1.child1_2' => true,
      'parent.child1.child1_2.no_exist' => false,
      'parent.child1.child1_3' => false,
      'parent.child2' => true,
      'no_exist' => false,
      'parent.child1' => true
    }.each do |entry_key, expected_value|
      it { expect(instance.key?(entry_key)).to eq(expected_value) }
    end
  end
end
