require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  include ApplicationHelper

  let(:base_title) { 'Chubakka' }

  subject { page }

  describe 'index' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_title('All Users') }
    it { should have_content('All Users') }

    describe 'pagination' do

      before(:all) { 30.times { create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe 'delete links' do

      it { should_not have_link('Delete') }

      describe 'as an admin user' do
        let(:admin) { create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('Delete', href: user_path(User.first)) }
        it 'should be able to delete another user' do
          expect do
            click_link('Delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('Delete', href: user_path(admin)) }

        it 'can not to delete admin user' do
          expect { delete user_path(admin) }.not_to change(User, :count)
        end
      end
    end
  end

  describe 'signup page' do

    before { visit signup_path }

    let(:submit) { 'Create My Account' }

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
      before { fill_signup_fields }

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@test.com') }

        it { should have_link('Sign Out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'profile page' do
    let(:user) { create(:user) }
    let!(:m1) { create(:micropost, user: user, content: 'Foo') }
    let!(:m2) { create(:micropost, user: user, content: 'Bar') }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe 'microposts' do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe 'follow/unfollow buttons' do
      let(:other_user) { create(:user) }
      before { sign_in user }

      describe 'following a user' do
        before { visit user_path(other_user) }

        it 'should increment the followed user count' do
          expect do
            click_button 'Follow'
          end.to change(user.followed_users, :count).by(1)
        end

        it 'should increment the other users followers count' do
          expect do
            click_button 'Follow'
          end.to change(other_user.followers, :count).by(1)
        end

        describe 'toggling the button' do
          before { click_button 'Follow' }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe 'unfollowing a user' do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it 'should decrement the followed user count' do
          expect do
            click_button 'Unfollow'
          end.to change(user.followed_users, :count).by(-1)
        end

        it 'should decrement the other users followers count' do
          expect do
            click_button 'Unfollow'
          end.to change(other_user.followers, :count).by(-1)
        end

        describe 'toggling the button' do
          before { click_button 'Unfollow' }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  describe 'edit' do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_content('Update Your Profile') }
      it { should have_title('Edit User') }
      it { should have_link('Change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button 'Save Changes' }

      it { should have_content('error') }
    end

    describe 'with valid information' do
      let(:new_name)  { 'New Name' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Name',             with: new_name
        fill_in 'Email',            with: new_email
        fill_in 'Password',         with: user.password
        fill_in 'Confirm Password', with: user.password
        click_button 'Save Changes'
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign Out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe 'forbidden attributes' do
      let(:params) { { user: { admin: true, password: user.password, password_confirmation: user.password } } }
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params: params
      end

      specify { expect(user.reload).not_to be_admin }
    end
  end

  describe 'following/followers' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    before { user.follow!(other_user) }

    describe 'followed users' do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe 'followers' do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
