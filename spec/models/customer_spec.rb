require 'rails_helper'

describe Customer do

  it "has a valid factory" do
    expect(create(:customer)).to be_valid
    # ensure uniqueness
    expect(create(:customer)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:customer, name: nil)).not_to be_valid
  end

  it "is invalid without a postcode" do
    expect(build(:customer, postcode: nil)).not_to be_valid
  end

  it "is invalid without a latitude" do
    expect(build(:customer, latitude: nil)).not_to be_valid
  end

  it "is invalid without a longitude" do
    expect(build(:customer, longitude: nil)).not_to be_valid
  end

end
