require 'uri'
require 'net/http'
require 'nokogiri'

class RouteCalculator

  BING_KEY =  Rails.application.config.deliveries[:bing_maps_key]
  HOME_LOC = Rails.application.config.deliveries[:home_location]
  # Optimize route by 'time' or 'timeWithTraffic' or 'distance'
  OPTIMIZE = 'distance'

  ## all points should be strings => 'lat,long'

  # find a route from current location via an array of waypoints
  def self.via_points(current_location, waypoints)
    # calculate from location to home via waypoints
    # have to use home otherwise you are saying one of 
    # the waypoints is last.
    calc(current_location, HOME_LOC, waypoints)
  end

  # find a route between two points
   def self.point_to_point(start, finish)
    calc(start, finish)
  end

  # find a route from a point to the home location
  def self.to_home(location)
    calc(location, HOME_LOC)
  end

  def self.calc(start, finish, waypoints=[])
    puts "start = #{start}"
    wps = "?wp.0=#{start}"
    waypoints.each_with_index do |wp, i|
      wps += "&vwp.#{i+1}=#{wp}"
    end
    wps += "&wp.#{waypoints.length + 1}=#{finish}"

    # options: '&routePathOutput=Points
    base_url = 'http://dev.virtualearth.net/REST/v1/Routes/Driving'
    escaped =  base_url + wps + "&optimize=#{OPTIMIZE}&key=" +
      BING_KEY + '&o=xml'
    url = URI.parse(escaped)
    response = Net::HTTP.get_response(url)

    response.body
  end

  def self.get_route_order(current_location, waypoints)
    data = via_points(current_location, waypoints)
    xmldoc = Nokogiri::XML(data)
    # remove namespaces, makes for tidier selection
    xmldoc.remove_namespaces!

    # get the sublegs, i.e. the waypoint order
    wpoints = []
    legs = xmldoc.xpath('//RouteSubLeg')
    legs.each do |leg|
      time = leg.at_xpath('.//TravelDuration').content.to_i
      endpoint = leg.at_xpath('.//EndWaypoint')
      lat = endpoint.at_xpath('.//Latitude').content.to_f.round(4)
      lon = endpoint.at_xpath('.//Longitude').content.to_f.round(4)
      idx = endpoint.at_xpath('.//RoutePathIndex').content
      wpoints << "#{idx},#{lat},#{lon},#{time}"
    end

    # dump the last entry, point to depot
    wpoints.pop
    # sort waypoints by idx, ensuring correct order
    wpoints.sort do |a,b|
      ai = a.split(',')[0]
      bi = b.split(',')[0]
      ai <=> bi
    end
  end

end