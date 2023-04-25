require 'httparty'

module OpenWeatherMap
  class Forecast
    BASE_URL = 'https://api.openweathermap.org/data/2.5'

    def initialize(api_key)
      @api_key = api_key
    end

    def forecast(city)
      data = []
      @city = city
      forecase_response = HTTParty.get("#{BASE_URL}/forecast?lat=#{lat}&lon=#{lon}&appid=#{@api_key}")
      OpenWeatherMap::Weather.new(@api_key, @city, BASE_URL, data).call
      data.push(find_min_and_max_temp(forecase_response))
      data
    end

    private

    def lat
      geocoded_city_response.first['lat']
    end

    def lon
      geocoded_city_response.first['lon']
    end

    def geocoded_city_response
      @geocoded_city_response ||= Geocode.new(@api_key).geocode(@city)
    end

    def find_min_and_max_temp(response)
      max_temp = nil
      min_temp = nil
      current_date = Time.now.localtime.strftime('%Y-%m-%d')
      response['list'].each do |forecast|
        forecast_date = Time.strptime(forecast['dt'].to_s, '%s').localtime.strftime('%Y-%m-%d')
        if forecast_date == current_date
          if max_temp.nil? || forecast['main']['temp_max'] > max_temp
            max_temp = forecast['main']['temp_max']
          end
          if min_temp.nil? || forecast['main']['temp_min'] < min_temp
            min_temp = forecast['main']['temp_min']
          end
        end
      end
      { max: max_temp, min: min_temp }
    end
  end
end
