require 'rails_helper'

describe "Uploads" do

  before :each do
    user = create(:admin)
    sign_in user
  end

  it "click on Upload button should open upload form" do
    visit root_path
    click_link 'Upload'
    expect(page).to have_css('h3', 'Upload Delivery')
  end

  it "should not do anything if file input is blank" do
    visit upload_path
    click_button 'Upload'
    expect(page).to have_content('A file must first be choosen to upload')
  end

  xit "should not upload an invalid file successfully" do
    visit upload_path
    page.attach_file('upload_file', invalid_csv_file)
    click_button 'Upload'
    expect(page).to have_content('file is inavlid')
  end

  it "should upload a valid file successfully" do
    visit upload_path
    page.attach_file('upload_file', valid_csv_file)
    click_button 'Upload'
    expect(page).to have_content('successfully uploaded')
  end

end