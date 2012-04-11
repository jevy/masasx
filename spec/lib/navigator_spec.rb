require 'spec_helper'

describe Navigator do

  describe '.steps' do

    context 'when no contact specified' do

      it 'returns the default navigation' do
        @organization = FactoryGirl.create(:organization, status: 'agreement')

        Navigator.steps(@organization).should eql Navigator::DEFAULT_NAVIGATION
      end

    end

    context 'when primary contact is executive' do

      it 'returns the default navigation' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin_executive))

        Navigator.steps(@organization).should eql Navigator::DEFAULT_NAVIGATION
      end

    end

    context 'when primary is not executive' do

      it 'returns the default navigation' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.build(:organization_admin) )

        Navigator.steps(@organization).should eql Navigator::DEFAULT_NAVIGATION
      end

    end

    context 'when secondary contact is executive' do

      it 'returns the default navigation' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin),
                                           secondary_organization_administrator: FactoryGirl.create(:organization_admin_executive)
                                          )

                                          Navigator.steps(@organization).should eql Navigator::DEFAULT_NAVIGATION
      end

    end


    context 'when primary is not executive and secondary is not persisted yet' do

      it 'returns the default navigation' do
        @organization = FactoryGirl.build(:organization, status: 'agreement')

        @organization.primary_organization_administrator   = FactoryGirl.build(:organization_admin)
        @organization.secondary_organization_administrator = FactoryGirl.build(:organization_admin)

        Navigator.steps(@organization).should eql Navigator::DEFAULT_NAVIGATION
      end

    end

  end

  context 'neither primary or seconday is executive' do

    it 'returns the extended navigation' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin),
                                           secondary_organization_administrator: FactoryGirl.create(:organization_admin)
                                          )

      Navigator.steps(@organization).should eql Navigator::EXTENDED_NAVIGATION
    end

  end

end
