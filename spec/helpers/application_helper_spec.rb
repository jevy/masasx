require 'spec_helper'

describe ApplicationHelper do

  describe '#title' do

    it 'should set the content_for :title' do
      helper.should_receive(:content_for).with(:title)

      helper.title('My Title')
    end

  end

  describe '#show_title?' do

    it 'should be true by default' do
      helper.title 'My Title'
      helper.show_title?.should be_true
    end

    it 'should be false when it is set to false' do
      helper.title 'My Title', false
      helper.show_title?.should be_false
    end

  end

  describe '#yesno_options' do

    it 'should return Yes and No' do
      helper.yesno_options.should eql([['Yes', true], ['No', false]])
    end

  end

end
