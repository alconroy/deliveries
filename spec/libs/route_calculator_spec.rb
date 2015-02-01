require 'rails_helper'
require 'route_calculator'

describe "Route Caclculator" do

  it "should return empty array if data is invalid" do
    coords = RouteCalculator.get_route_order('', [])
    expect(coords).to be_empty
  end

  it "should return correct route order" do
    start = '53.8143,-1.5527'
    wapoints = ['53.8002,-1.5492','53.8085,-1.5616']
    order = RouteCalculator.get_route_order(start, wapoints)
    expect(order.length).to be_equal(2)
    expect(order[0]).to be_eql('51,53.8002,-1.5492')
    expect(order[1]).to be_eql('75,53.8085,-1.5616')
  end

end