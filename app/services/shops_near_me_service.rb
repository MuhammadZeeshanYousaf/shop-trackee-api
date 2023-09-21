class ShopsNearMeService < ApplicationService

  def initialize(distance, latitude, longitude)
    @distance, @latitude, @longitude = distance.to_i, latitude.to_f, longitude.to_f
  end

  def call
    locations = Shop.where.not(latitude: nil, longitude: nil).pluck(:id, :latitude, :longitude)
    search_ids = []
    locations.each do |id, lat, long|
      distance = Haversine.distance(lat, long, @latitude, @longitude)
      if @distance >= distance.to_km
        search_ids << id
      end
    end
    search_ids
  end

end
