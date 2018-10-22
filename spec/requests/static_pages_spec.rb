require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Chubakka" }

  describe "Home Page" do
    it "should have the content 'Chubakka'" do
      visit '/static_pages/home'
      expect(page).to have_content('Chubakka')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title('Chubakka')
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).to_not have_title("#{base_title} | Home")
    end
  end

  describe "Help Page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About Page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About Us")
    end
  end

  describe "Help Page" do
    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
