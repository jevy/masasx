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

  describe '#show_address' do

    before do
      class FakeModel
        attr_accessor :address_line_1, :address_line_2, :city, :country, :state, :postal_code
      end
      @model_with_address = FakeModel.new
      @model_with_address.address_line_1 = 'Line 1'
    end

    context 'when only address line 1' do

      it 'returns a formatted address line 1' do
        helper.show_address(@model_with_address).should eql '<span>Line 1</span>'
      end

    end

    context 'when only address line 1 and address line 2' do

      it 'returns a formatted address line 2' do
        @model_with_address.address_line_2 = 'Line 2'
        helper.show_address(@model_with_address).should eql '<span>Line 1<br/>Line 2</span>'
      end

    end

    context 'when address line 1 and any of the secondary fields' do

      it 'returns a formatted city' do
        @model_with_address.city = 'city'
        helper.show_address(@model_with_address).should eql '<span>Line 1<br/>city</span>'
      end

      it 'returns a formatted country' do
        @model_with_address.city    = 'city'
        @model_with_address.country = 'country'
        helper.show_address(@model_with_address).should eql '<span>Line 1<br/>city, country</span>'
      end

    end

    context 'when address line 1, address line 2 any of the secondary fields' do
      before do
        @model_with_address.address_line_2 = 'Line 2'
      end

      it 'returns a formatted city' do
        @model_with_address.city = 'city'
        helper.show_address(@model_with_address).should eql '<span>Line 1<br/>Line 2<br/>city</span>'
      end

      it 'returns a formatted country' do
        @model_with_address.city    = 'city'
        @model_with_address.country = 'country'
        helper.show_address(@model_with_address).should eql '<span>Line 1<br/>Line 2<br/>city, country</span>'
      end

    end

  end

end
