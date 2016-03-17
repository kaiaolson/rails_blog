require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  describe "Sign In" do

    context "with valid credentials" do
      it "redirects to home page / shows the user's full name / displays text 'Sign in successful'" do
        visit new_session_path

        fill_in "Email", with: user.email
        fill_in "Password", with: user.password

        click_button "Log in"

        user_full_name = "#{user.first_name} #{user.last_name}"

        expect(current_path).to eq(root_path)
        expect(page).to have_text /Sign in successful/i
        expect(page).to have_text /#{user_full_name}/i

      end
    end

    context "with invalid credentials" do
      it "doesn't show the user full name / it displays text 'wrong credentials'" do
        visit new_session_path

        invalid_user = FactoryGirl.attributes_for(:user)

        fill_in "Email", with: invalid_user[:email]
        fill_in "Password", with: invalid_user[:password]
        click_button "Log in"

        user_full_name = "#{invalid_user[:first_name]} #{invalid_user[:last_name]}"

        expect(page).to_not have_text /#{user_full_name}/i
        expect(page).to have_text /wrong credentials/i
      end
    end
  end
  describe "Sign Out" do
    before do
      visit new_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Log in"
    end
    it "displays the home page / it displays text 'logged out'" do
      click_link "Log Out"

      expect(current_path).to eq(root_path)
      expect(page).to have_text /logged out/i
    end
  end
end
