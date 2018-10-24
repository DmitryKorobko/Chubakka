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
