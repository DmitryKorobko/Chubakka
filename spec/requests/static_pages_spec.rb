require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "Home Page" do
    it "should have the content 'Chubakka'" do
      visit '/static_pages/home'
      expect(page).to have_content('Chubakka')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("Chubakka | Home")
    end
  end

  describe "Help Page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("Chubakka | Help")
    end
  end

  describe "About Page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("Chubakka | About Us")
    end
  end
end
