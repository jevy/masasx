require 'spec_helper'

describe Account do

  it { should respond_to(:name) }

  it { should respond_to(:access_code) }

  it { should respond_to(:permissions_store) }

  context 'permissions' do

    before do
      @account = Account.new
    end

    it 'has denies all permissions by default' do
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
      @account.should_receive(:update_attribute).with(:permissions_store, kind_of(String))
      expect {
        @account.can!(:write, CmsService)
      }.to change { @account.can?(:write, CmsService) }.from(false).to(true)
    end

    it 'cant! doesnt grant a service for :write' do
      @account.can!(:write, CmsService)

      @account.should_receive(:update_attribute).with(:permissions_store, kind_of(String))
      expect {
        @account.cant!(:write, CmsService)
      }.to change { @account.can?(:write, CmsService) }.from(true).to(false)
    end

    it 'can! grants a service for :read' do
      @account.should_receive(:update_attribute).with(:permissions_store, kind_of(String))

      expect {
        @account.can!(:read, CmsService)
      }.to change { @account.can?(:read, CmsService) }.from(false).to(true)
    end

    it 'cant! doesnt grant a service for :read' do
      @account.can!(:read, CmsService)

      @account.should_receive(:update_attribute).with(:permissions_store, kind_of(String))
      expect {
        @account.cant!(:read, CmsService)
      }.to change { @account.can?(:read, CmsService) }.from(true).to(false)
    end

  end

end
