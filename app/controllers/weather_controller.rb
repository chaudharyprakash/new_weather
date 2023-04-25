# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index
  end

  def forecast
    api_key = Rails.application.credentials.open_weather_map[:api_key]
    service = OpenWeatherMap::Forecast.new(api_key)

    @forecast, @current_weather = service.forecast(params[:city])
    # @forecast = response.parsed_response['list']

    if @forecast.present?
      render :forecast
    else
      render :index
    end
  end
end

