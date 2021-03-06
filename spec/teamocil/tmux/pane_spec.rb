require 'spec_helper'

RSpec.describe Teamocil::Tmux::Pane do
  describe :as_tmux do
    let(:pane) { Teamocil::Tmux::Pane.new(commands: commands, root: root, index: index, focus: focus) }
    let(:as_tmux) { pane.as_tmux }
    let(:pane_base_index) { Random.rand(0..100) }

    before do
      allow(Teamocil::Tmux::Pane).to receive(:pane_base_index).and_return(pane_base_index)
    end

    # Pane attributes
    let(:commands) { %w(foo bar) }
    let(:root) { '/tmp' }
    let(:focus) { true }

    context 'for first pane' do
      let(:index) { 0 }

      it do
        expect(as_tmux).to eql [
          Teamocil::Command::SendKeysToPane.new(index: pane_base_index, keys: 'foo; bar'),
          Teamocil::Command::SendKeysToPane.new(index: pane_base_index, keys: 'Enter')
        ]
      end
    end

    context 'for not-first pane' do
      let(:index) { 1 }

      it do
        expect(as_tmux).to eql [
          Teamocil::Command::SplitWindow.new(root: root),
          Teamocil::Command::SendKeysToPane.new(index: pane_base_index + index, keys: 'foo; bar'),
          Teamocil::Command::SendKeysToPane.new(index: pane_base_index + index, keys: 'Enter')
        ]
      end
    end
  end
end
