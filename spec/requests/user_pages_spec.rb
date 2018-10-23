require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  include ApplicationHelper

  let(:base_title) { 'Chubakka' }

  subject { page }

  describe 'signup page' do

    before { visit signup_path }

    let(:submit) { 'Create my account' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_title('Sign Up') }
        it { should have_content('error') }
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Name',         with: 'Test User'
        fill_in 'Email',        with: 'user@test.com'
        fill_in 'Password',     with: '12345678'
        fill_in 'Confirmation', with: '12345678'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@test.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'profile page' do
    let(:user) { create(:user) }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
