require 'rails_helper'
require 'post_code_finder'

describe "Post Code Query" do

  it "should handle a single result" do
    coords = PostCodeFinder.query("WF13 3JY")
    expect(coords[:lat]).to equal(53.6778)
    expect(coords[:lon]).to equal(-1.6616)
  end

  it "should choose first result when more than one is returned" do
    coords = PostCodeFinder.query("WF13")
    expect(coords[:lat]).to equal(53.6893)
    expect(coords[:lon]).to equal(-1.6488)
  end

  it "should return nil if there are no results" do
    coords = PostCodeFinder.query("HX5 OEE")
    expect(coords).to be_nil
  end

  it "should return nil if parse data is invalid" do
    expect(PostCodeFinder.parse('')).to be_nil
  end

end

describe "Post Code Nearest Road Point" do

  it "should return nil if data is invalid" do
    expect(PostCodeFinder.nearest_road_point({lat: 'X', lon: 'Y'})).to be_nil
  end

  it "should return same point if all already on road" do
    coords = PostCodeFinder.nearest_road_point({lat: 52.3914, lon: -1.8039})
    expect(coords[:lat]).to be_equal(52.3914)
    expect(coords[:lon]).to be_equal(-1.8039)
  end

  it "should return cloesest road point to given point" do
    coords = PostCodeFinder.nearest_road_point({lat: 52.2862, lon: -1.7778})
    expect(coords[:lat]).to be_equal(52.2875)
    expect(coords[:lon]).to be_equal(-1.7777)
  end

end