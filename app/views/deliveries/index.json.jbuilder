json.array!(@deliveries) do |delivery|
  json.extract! delivery, :id, :user_id, :customer_id, :date, :precedence,
    :complete, :travel_time
  json.customer delivery.customer, :name, :address, :latitude, :longitude
end
