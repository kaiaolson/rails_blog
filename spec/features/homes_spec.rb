require 'rails_helper'

RSpec.feature "Homes", type: :feature do
  describe "Home Page" do
    it "has an h1 with text 'Welcome to my Ruby on Rails Blog'" do
      visit root_path
      expect(page).to have_selector "h1", text: /Welcome to my Ruby on Rails Blog/i
    end
  end
end
