require 'rails_helper'

RSpec.describe "Geolocations", type: :request do
  let(:ip_with_ipv4) { create(:ip_with_ipv4) }
  let(:ip_with_ipv6) { create(:ip_with_ipv6) }
  let(:ip_with_url) { create(:ip_with_url) }

  let(:geolocations) { [ip_with_ipv4, ip_with_ipv6, ip_with_url]}
  
  # Get all geolocations - index action
  describe "GET /index" do
    before { geolocations }
    context 'default behavior' do
      before { get '/geolocations' }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives a json' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 geolocations' do
        expect(json_body['data'].size).to eq 3
      end
    end
  end

  # Get single geolocation by ID - show action
  describe 'GET /geolocations/:id' do
    context 'with existing resource' do
      before { get "/geolocations/#{ip_with_ipv4.id}" }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the "ip_with_ipv4" as JSON' do
        expected = { data: ip_with_ipv4 }
        expect(response.body).to eq(expected.to_json)
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        get '/geolocations/2314323'
        expect(response.status).to eq 404
      end
    end
  end

  # Delete one geolocation by ID - delete action
  describe 'DELETE /geolocations/:id' do
    context 'with existing resource' do
      before { delete "/geolocations/#{ip_with_ipv6.id}" }

      it 'gets HTTP status 204' do
        expect(response.status).to eq 204
      end

      it 'deletes the geolocation from the database' do
        expect(Geolocation.count).to eq 0
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        delete '/geolocations/2314323'
        expect(response.status).to eq 404
      end
    end
  end

  # Create geolocation - create action
  describe 'POST /geolocations' do
    before { post '/geolocations', params: { data: params } }

    context 'with valid parameters' do
      let(:params) do
        attributes_for(:ip_with_url, ip: "TestURL")
      end

      it 'gets HTTP status 201' do
        expect(response.status).to eq 201
      end

      it 'receives the newly created resource' do
        expect(json_body['data']['ip']).to eq 'TestURL'
      end

      it 'adds a record in the database' do
        expect(Geolocation.count).to eq 1
      end

      it 'gets the new resource location in the Location header' do
        expect(response.headers['Location']).to eq(
          "http://www.example.com/geolocations/#{Geolocation.first.id}"
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) { attributes_for(:ip_with_url, ip: '') }

      it 'gets HTTP status 422' do
        expect(response.status).to eq 422
      end

      it 'receives the error details' do
        expect(json_body['error']['invalid_params']).to eq(
          { 'ip'=>["can't be blank"] }
        )
      end

      it 'does not add a record in the database' do
        expect(Geolocation.count).to eq 0
      end
    end
  end
end
