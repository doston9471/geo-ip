FactoryBot.define do
  factory :ip_with_ipv4, class: Geolocation do
    ip { "134.201.250.155"}
    latitude { 34.0655517578125 }
    longitude { -118.24053955078125 }
  end

  factory :ip_with_ipv6, class: Geolocation do
    ip { "2001:db8:3333:4444:5555:6666:7777:8888"}
    latitude { 35.2375812270229 }
    longitude { -110.27612545512133 }
  end

  factory :ip_with_url, class: Geolocation do
    ip { "google.com"}
    latitude { 37.419158935546875 }
    longitude { -122.07540893554688 }
  end
end