require 'spec_helper'

describe Account do

  it { should respond_to(:name) }

  it { should respond_to(:access_code) }

  it { should respond_to(:permissions_store) }

  it { should respond_to(:permissions_attributes) }

  it { should respond_to(:organization) }

  context 'permissions_attributes' do

    before do
      @account = Account.new
    end

    it 'accepts permissions thought permissions_attributes' do
      @account.permissions_attributes = {'CmsService' => {read: 'true', write: 'false'} }

      @account.can?(:read, CmsService).should be true
      @account.can?(:write, CmsService).should be false
    end

    it 'accepts multiple permissions thought permissions_attributes' do
      @account.permissions_attributes = {'CmsService' => {read: 'true', write: 'false'}, 'ExerciseHub' => {read: 'false', write: 'true'} }

      @account.can?(:read, CmsService).should be true
      @account.can?(:write, CmsService).should be false
      @account.can?(:read, ExerciseHub).should be false
      @account.can?(:write, ExerciseHub).should be true
    end
  end

  context 'permissions' do

    before do
      @account = Account.new
    end

    it 'denies all permissions by default' do
      @account.permissions_store.should eql '0000'
    end

    it 'can? should be false by default for :read' do
      @account.can?(:read, CmsService).should be false
    end

    it 'can? should be true when granted for :read' do
      @account.can!(:read, CmsService)
      @account.can?(:read, CmsService).should be true
    end

    it 'can? should false by default for :write' do
      @account.can?(:write, CmsService).should be false
    end

    it 'can? should be true when granted for :write' do
      @account.can!(:write, CmsService)
      @account.can?(:write, CmsService).should be true
    end

    it 'can! grants a service for :write' do
      @account.should_receive(:permissions_store_will_change!)
      expect {
        @account.can!(:write, CmsService)
      }.to change { @account.can?(:write, CmsService) }.from(false).to(true)
    end

    it 'cant! doesnt grant a service for :write' do
      @account.can!(:write, CmsService)

      @account.should_receive(:permissions_store_will_change!)
      expect {
        @account.cant!(:write, CmsService)
      }.to change { @account.can?(:write, CmsService) }.from(true).to(false)
    end

    it 'can! grants a service for :read' do
      @account.should_receive(:permissions_store_will_change!)

      expect {
        @account.can!(:read, CmsService)
      }.to change { @account.can?(:read, CmsService) }.from(false).to(true)
    end

    it 'cant! doesnt grant a service for :read' do
      @account.can!(:read, CmsService)

      @account.should_receive(:permissions_store_will_change!)
      expect {
        @account.cant!(:read, CmsService)
      }.to change { @account.can?(:read, CmsService) }.from(true).to(false)
    end

    it 'cant! for :write doesnt change :read' do
     @account.can!(:read, CmsService)

      expect {
        @account.cant!(:write, CmsService)
      }.to_not change { @account.can?(:read, CmsService) }
    end

    it 'cant! for :read doesnt change :write' do
     @account.can!(:write, CmsService)

      expect {
        @account.cant!(:read, CmsService)
      }.to_not change { @account.can?(:write, CmsService) }
    end

  end

end
