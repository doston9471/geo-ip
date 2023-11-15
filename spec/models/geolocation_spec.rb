require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  it { should validate_presence_of(:ip) }
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }

  it 'has a valid factory' do
    expect(build(:ip_with_ipv4)).to be_valid
    expect(build(:ip_with_ipv6)).to be_valid
    expect(build(:ip_with_url)).to be_valid
  end

  it 'handles database connection error gracefully' do
    allow(ActiveRecord::Base.connection).to receive(:active?).and_raise(ActiveRecord::NoDatabaseError)

    expect { Geolocation.all }.not_to raise_error
  end
end
