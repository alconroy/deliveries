require 'post_code_finder'

class Customer < ActiveRecord::Base
  has_many :deliveries

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :postcode, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  # On updating a record check the postcode and roadway coords in case they
  # have changed
  before_validation(on: :update) do
    # get the postcode coords for this record
    coords = PostCodeFinder.get(postcode)
    if coords.nil?
      # nothing found for this code, will be flagged to user
      self.latitude = 0
      self.longitude = 0
    else
      # find nearest point to the postcode that is on a road
      nrp = PostCodeFinder.nearest_road_point(
        {lat: coords[:lat], lon: coords[:lon]})
      if nrp.nil?
        # no nearest road found
        self.latitude = 0
        self.longitude = 0
      else
        self.latitude = nrp[:lat]
        self.longitude = nrp[:lon]
      end
    end
  end
end
