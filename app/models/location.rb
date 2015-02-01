class Location < ActiveRecord::Base
  belongs_to :user

  validates :time, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  protected

  # get the latest locations for each user (excluding admin)
  def self.latest_by_users
    latest = []
    users = User.where(admin: false)
    users.each do |u|
      location = u.locations.where(user_id: u.id,
        time: Time.now.midnight..(Time.now.midnight + 1.day)).order(time: :desc).first
      #puts "[locations] #{location.time}, #{location.latitude}, #{location.longitude}"
      latest << location unless location.nil?
    end
    latest
  end

  # remove old records, best to trigger on upload of new deliveries
  def self.remove_old
    # set period of time to delete old location data
    # NOTE: this may need to be tweaked if DB is storing too many locations.
    time_period = 2.hours
    Location.where('time < ?', Time.now.midnight - time_period).delete_all
  end

end
