require 'route_calculator'

class Delivery < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer

  validates :user, presence: true
  validates :customer, presence: true
  validates :date, presence: true

  # Starts the route calculation process, for a van/user.
  def self.calculate(user)
      #puts "[calc] starting...user=#{user.id}"
    # clear precedence values first
    clear(user)
    # get all non complete deliveries
    deliveries = Delivery.where(user: user, date: Date.today, complete: nil)
      #puts "[calc] deliveries=#{deliveries.length}"
    # get the latest known location of user
    current = Location.where(user: user).last
    current_str = "#{current.latitude},#{current.longitude}"
      #puts "[calc] curr_coords=#{current_str}"
    # create a string of waypoints (deliveries)
    deliveries_str = []
    deliveries.each do |d|
      deliveries_str << "#{d.customer.latitude},#{d.customer.longitude}"
        #puts ">> #{d.customer.latitude},#{d.customer.longitude}"
    end
    # get route in order, will already be sorted (coords rounded to 3 places)
    route_list = RouteCalculator.get_route_order(current_str, deliveries_str)
    route_list.each_with_index do |rl, idx|
      wp = rl.split(',')
      ord = wp[0]
      lat = wp[1].to_f.round(3)
      lon = wp[2].to_f.round(3)
      time = wp[3].to_i
        #puts "[calc] route_list(#{idx})=#{ord}, #{lat}, #{lon}, #{time}"
      deliveries.each do |d|
        c = d.customer
        clat = c.latitude.to_f.round(3)
        clon = c.longitude.to_f.round(3)
          #puts "[calc] matching...(#{c.latitude}, #{c.longitude})"
        # match customer to route waypoint
        if clat == lat && clon == lon
            #puts "[calc] match found"
          Delivery.update(d.id, precedence: idx + 1, travel_time: time)
        end
      end
    end
  end

  # Set all deliveries for this user for today to have a precedence of nil.
  # Ensures route is (re)calculated cleanly.
  def self.clear(user)
    deliveries = Delivery.where(user: user, date: Date.today)
    deliveries.each do |d|
      Delivery.update(d.id, precedence: nil)
    end
  end

  # remove old records, best to trigger on upload of new deliveries
  def self.remove_old()
    # set period of time to delete old deliveries
    time_period = 1.month
    Delivery.where('date < ?', Time.now.midnight - time_period).destroy_all
  end

end
