require 'httparty'

module OpenWeatherMap
  class Weather

    def initialize(api_key, city, base_url, data)
      @api_key = api_key
      @city = city
      @base_url = base_url
      @data = data
    end

    def call
      weather_response = HTTParty.get("#{@base_url}/weather?q=#{@city}&appid=#{@api_key}&units=metric")
      if weather_response['cod'] == '404'
        raise "City '#{city}' not found"
      end
      @data.push(find_current_temp(weather_response))
      @data
    end

    private

    def find_current_temp(weather_response)
      temperature = weather_response['main']['temp']
      humidity = weather_response['main']['humidity']
      weather_description = weather_response['weather'][0]['description']
      icon = weather_response['weather'][0]["icon"]
      { temperature: temperature, humidity: humidity, description: weather_description, icon: icon}
    end
  end
end
