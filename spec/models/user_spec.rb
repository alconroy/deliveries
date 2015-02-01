require 'rails_helper'

describe User do

  it "has a valid factory" do
		expect(create(:user)).to be_valid
	end

	it "is invalid without an email" do
		expect(build(:user, email: nil)).not_to be_valid
	end

	it "allows only valid email addresses" do
		expect(build(:user, email: 'user@example.com')).to be_valid
		expect(build(:user, email: 'user@example')).not_to be_valid
		expect(build(:user, email: 'user at example dot com')).not_to be_valid
	end

	it "has unique email addresses" do
		create(:user, email: 'one@example.com')
		expect(build(:user, email: 'one@example.com')).not_to be_valid
	end

	it "is invalid wihtout a password" do
		expect(build(:user, password: nil)).not_to be_valid
		expect(build(:user, password_confirmation: nil)).not_to be_valid
	end

	it "must have password longer than 5 characters" do
		expect(build(:user, password: '12345', password_confirmation: '12345')).not_to be_valid
		expect(build(:user, password: '123456', password_confirmation: '123456')).to be_valid
	end

	it "has a confirmed matching password" do
		expect(build(:user, password: 'abc123', password_confirmation: 'abc123')).to be_valid
		expect(build(:user, password: 'abc123', password_confirmation: 'cba321')).not_to be_valid
	end

	it "has admin status false as default" do
		expect(build(:user).admin).to eql(false)
	end

end
