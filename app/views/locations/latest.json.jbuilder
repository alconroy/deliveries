json.array!(@locations) do |location|
  json.extract! location, :time, :user_id, :latitude, :longitude
  json.user location.user, :email, :van
end