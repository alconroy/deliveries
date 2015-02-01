require 'rails_helper'

describe Delivery do
  it "has a valid factory" do
    expect(create(:delivery)).to be_valid
  end

  it "is invalid without a user" do
    expect(build(:delivery, user: nil)).not_to be_valid
  end

  it "is invalid without a customer" do
    expect(build(:delivery, customer: nil)).not_to be_valid
  end

  it "is invalid without a date" do
    expect(build(:delivery, date: nil)).not_to be_valid
  end
end
