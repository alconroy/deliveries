require 'rails_helper'

describe "UserLogin" do

  it "need to login to access home page" do
    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('sign in')
  end

   it "standard user logs in to basic home page" do
    user = create(:user)
    sign_in user

    expect(page).to have_content('Signed in successfully')
    expect(page).to_not have_css('li a', text: "Manage Users")
  end

  it "admin user logs in to admin page" do
    user = create(:admin)
    sign_in user

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_css('li a', text: "Manage Users")
  end

  it "users should be logged out on sign out" do
    user = create(:user)
    sign_in user

    expect(page).to have_content('Signed in successfully')
    click_link 'Sign Out'
    visit root_path
    expect(page).to have_content('sign in')
  end

  it "should only allow admins to access Admin areas" do
      user = create(:user)
      sign_in user
      visit users_path
      expect(page).to have_content("Unauthorized access")
  end

end

describe "AdminRole"  do

  before :each do
    @user = create(:admin)
    sign_in @user
  end

  it "should have access to list of users" do
    visit users_path
    expect(page).to have_css('h2', text: 'Users')
  end

  it "should be able to create new standard user" do
    new_user_email = create_new_user
    new_user = User.find_by_email(new_user_email)
    expect(new_user).to be_truthy
    expect(new_user.admin).to be_falsy
  end

  it "should be able to create new admin user" do
    new_user_email = create_new_user true
    expect(page).to have_content('User was successfully created')
    expect(User.find_by_email(new_user_email).admin).to be_truthy
  end

  it "should be able to delete a user" do
    new_user_email = create_new_user
    new_user = User.find_by_email(new_user_email)

    # find user email row and get correct delete link
    delete_link = find(:xpath, "//div[div[text()[normalize-space() = " +
      "'#{new_user_email}']]]/div/a[@data-method='delete']")
    delete_link.click

    expect(page).to have_content('User was successfully deleted.')
  end

  it "should be able to acces users edit page" do
    new_user_email = create_new_user
    new_user = User.find_by_email(new_user_email)

    # find user email row and get correct edit link
    edit_link = find(:xpath, "//div[div[text()[normalize-space() = " +
      "'#{new_user_email}']]]/div/a[text()[normalize-space() = 'Edit']]")
    edit_link.click

    expect(page).to have_css('h3', text: 'Edit User')
    expect(page).to have_css("input[value='#{new_user_email}']")
  end

  it "should be able to edit a users details without entering their password" do
    edit_user = create(:user)
    visit edit_user_path(edit_user.id)
    expect(page).to have_content('Edit User')

    check 'user_admin'
    click_button 'Update'

    expect(page).to_not have_content('errors')
    expect(page).to have_content('User was successfully updated')
  end

  it "should not be able to remove own admin status" do
    visit edit_user_path(@user.id)
    expect(page).to_not have_css('input#user_admin')
  end

end
