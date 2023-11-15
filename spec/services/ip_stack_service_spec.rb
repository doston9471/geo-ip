require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe IpStackService, type: :service do
  describe '#call' do
    let(:api_key) { 'your_private_api_key' }
    let(:api_url) { 'https://api.ipstack.com/' }
    let(:ip_address) { '8.8.8.8' }
    let(:service) { IpStackService.new(ip_address) }

    before do
      ENV['PRIVATE_API_KEY'] = api_key
      ENV['API_URL'] = api_url
    end

    it 'makes a request to the IpStack API', :vcr do
      VCR.use_cassette('ipstack_api_request') do
        result = service.call

        expect(result).to be_a(Hash)
        expect(result[:latitude]).to eq(40.5369987487793)
        expect(result[:longitude]).to eq(-82.12859344482422)
      end
    end
  end
end
