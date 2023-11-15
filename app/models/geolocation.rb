class Geolocation < ApplicationRecord
  validates :ip, :latitude, :longitude, presence: true
end
