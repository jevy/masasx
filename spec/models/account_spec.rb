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
      @account.permissions.should =~ MasasService.all
    end

    it 'can_read?' do
      @account.should_not can_read(CmsService)
    end

    it 'can_read?' do
      @account.can!(:read, CmsService)
      @account.should_not be_can(:read, CmsService)
    end

    it 'can_write?' do
      @account.should_not be_can(:write, CmsService)
    end

    it 'can_write?' do
      @account.can!(:write, CmsService)
      @account.should_not be_can(:write, CmsService)
    end

    it 'can_write!' do
      expect {
        @account.can!(:write, CmsService)
      }.to change(@account,:can?,:write, CmsService).from(false).to(true)
    end

    it 'cant_write!' do
      @account.can!(:write, CmsService)
      expect {
        @account.cant!(:write, CmsService)
      }.to change(@account,:can?, :write, CmsService).from(true).to(false)
    end

    it 'can_read!' do
      expect {
        @account.can!(:read, CmsService)
      }.to change(@account,:can?, :read, CmsService).from(false).to(true)
    end

    it 'cant_read!' do
      @account.can!(:read, CmsService)
      expect {
        @account.cant!(:read, CmsService)
      }.to change(@account,:can?,:read, CmsService).from(true).to(false)
    end

  end

end
