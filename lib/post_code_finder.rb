require 'uri'
require 'net/http'
require 'nokogiri'

require 'route_calculator'

class PostCodeFinder

  BING_KEY =  Rails.application.config.deliveries[:bing_maps_key]

  def self.get(postcode)
    puts "querying: #{postcode}"
    postcode_loc = query(postcode)
    return nil if postcode_loc.nil?
    nearest_road_point(postcode_loc)
  end

  def self.query(postcode)
      base_url = 'http://dev.virtualearth.net/REST/v1/Locations'
      # escape the postcode part of the url
      # can also use '?query=' for a more general search e.g. an address
      escaped =  base_url + '?postalCode=' + CGI.escape(postcode) +
        '&key=' + BING_KEY + '&o=xml'
      url = URI.parse(escaped)
      response = Net::HTTP.get_response(url)
      # parse response body content
      parse(response.body)
  end

  def self.parse(data)
    xmldoc = Nokogiri::XML(data)
    # remove namespaces, makes for tidier selection
    xmldoc.remove_namespaces!
    # get all location points
    lats = xmldoc.xpath('//Location//Point//Latitude')
    longs = xmldoc.xpath('//Location//Point//Longitude')
    # check if there are any results & take the first values
    if lats.empty? || longs.empty?
      # no results
      return nil
    else
      lat = lats.first.content
      lon = longs.first.content
      # return as hash
      return { lat: lat.to_f.round(4), lon: lon.to_f.round(4) }
    end
  end

  def self.nearest_road_point(coords)
    data = RouteCalculator.to_home("#{coords[:lat]},#{coords[:lon]}")
    xmldoc = Nokogiri::XML(data)
    xmldoc.remove_namespaces!
    # get the calculated nearest road point
    lat = xmldoc.at_xpath('//ActualStart//Latitude')
    lon = xmldoc.at_xpath('//ActualStart//Longitude')
    if lat.blank? || lon.blank?
      # no results
      return nil
    else
      # return as hash
      return { lat: lat.content.to_f.round(4), lon: lon.content.to_f.round(4) }
    end
  end

end