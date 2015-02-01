module Features
  module SessionHelpers

      def sign_in(user)
        visit root_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'Sign In'
      end

      def create_new_user(admin=false)
        user_email = 'newuser@example.com'
        user_pass = '123456'
        visit users_path
        click_link "New User"
        expect(page).to have_css('h3', text: 'Create New User')
        fill_in 'user_email', with: user_email
        fill_in 'user_password', with: user_pass
        fill_in 'user_password_confirmation', with: user_pass
        if admin
          check 'user_admin'
        else
          uncheck 'user_admin'
        end
        click_button "Create"
        return user_email
      end

  end
end