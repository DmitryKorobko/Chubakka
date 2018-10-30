require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  include ApplicationHelper

  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  subject { page }

  describe 'Home Page' do
    before { visit root_path }
    let(:heading)    { 'Chubakka' }
    let(:page_title) { '' }

    it_should_behave_like 'all static pages'
    it { should_not have_title('| Home') }

    describe 'for signed-in users' do
      let(:user) { create(:user) }
      before do
        create(:micropost, user: user, content: 'Lorem ipsum')
        create(:micropost, user: user, content: 'Dolor sit amet')
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe 'follower/following counts' do
        let(:other_user) { create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link('0 following', href: following_user_path(user)) }
        it { should have_link('1 followers', href: followers_user_path(user)) }
      end
    end
  end

  describe 'Help Page' do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { heading }

    it_should_behave_like 'all static pages'
  end

  describe 'About Page' do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { heading }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact Page' do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { heading }

    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    right_layout_links
  end
end
