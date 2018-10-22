require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Chubakka' }

  subject { page }

  describe 'Home Page' do
    before { visit root_path }

    it { should have_content('Chubakka') }
    it { should have_title('Chubakka') }
    it { should_not have_title('| Home') }
  end

  describe 'Help Page' do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title("#{base_title} | Help") }
  end

  describe 'About Page' do
    before { visit about_path }

    it { should have_content('About Us') }
    it { should have_title("#{base_title} | About Us") }
  end

  describe 'Contact Page' do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title("#{base_title} | Contact") }
  end
end
