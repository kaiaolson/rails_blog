require 'rails_helper'

RSpec.feature "Users", type: :feature do
  describe "Sign Up" do
    context "with valid information" do
      it "redirects to the home page / displays the user's full name / displays 'Sign up successful!' message" do
        visit new_user_path

        valid_user = FactoryGirl.attributes_for(:user)

        fill_in "First name", with: valid_user[:first_name]
        fill_in "Last name", with: valid_user[:last_name]
        fill_in "Email", with: valid_user[:email]
        fill_in "Password", with: valid_user[:password]
        fill_in "Password confirmation", with: valid_user[:password]

        user_full_name = "#{valid_user[:first_name]} #{valid_user[:last_name]}"

        click_button "Create User"
        expect(current_path).to eq(root_path)
        expect(page).to have_text /#{user_full_name}/i
        expect(page).to have_text /Sign up successful!/i

      end
    end

    context "with invalid information" do
      it "alerts the user with 'Fail' and it doesn't show the user's name" do
        visit new_user_path
        fill_in "First name", with: "Kaia"
        click_button "Create User"

        expect(page).to have_text /Sign up unsuccessful./i
        expect(page).to_not have_text /kaia/i
      end
    end
  end
end
