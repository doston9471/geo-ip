require 'net/http'
require 'uri'
require 'json'

class IpStackService < ApplicationService
  PRIVATE_API_KEY = ENV['PRIVATE_API_KEY']
  API_URL = ENV['API_URL']

  def initialize(addr)
    @addr = addr
  end

  def call
    response = make_request(addr: @addr)
    result = parse_response(response.body)
  end

  private

  def make_request(addr:)
    uri = URI.parse("#{API_URL}#{addr}?access_key=#{PRIVATE_API_KEY}&output=json")
    request = Net::HTTP::Get.new(uri)
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def parse_response(body)
    JSON.parse(body, symbolize_names: true)
  rescue => e
    return e
  end
end