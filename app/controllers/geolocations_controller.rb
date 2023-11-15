class GeolocationsController < ApplicationController

  def index
    render json: { data: Geolocation.all }
  end

  def show
    render json: { data: geolocation }
  end

  def create
    geolocation = Geolocation.new(geolocation_params)
    addr = params[:data][:ip]
    latitude = params[:data][:latitude]
    longitude = params[:data][:longitude]

    if latitude.nil? || longitude.nil?
      result = IpStackService.call(addr)
      if result[:ip].present?
        geolocation[:latitude] = result[:latitude]
        geolocation[:longitude] = result[:longitude]
        if geolocation.save
          render json: { data: geolocation }, status: :created, location: geolocation
        else
          unprocessable_entity!(geolocation)
        end
      else
        render json: result[:error]
      end
    else
      if geolocation.save
        render json: { data: geolocation }, status: :created, location: geolocation
      else
        unprocessable_entity!(geolocation)
      end
    end
  end

  def destroy
    geolocation.destroy
    render status: :no_content
  end

  private

  def geolocation
    @geolocation = Geolocation.find_by!(id: params[:id])
  end
  alias_method :resource, :geolocation

  def geolocation_params
    params.require(:data).permit(:ip, :latitude, :longitude)
  end
end
