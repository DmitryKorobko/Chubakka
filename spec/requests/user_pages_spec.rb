require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  include ApplicationHelper

  let(:base_title) { 'Chubakka' }

  subject { page }

  describe 'signup page' do
    before { visit signup_path }
    let(:page_title) { 'Sign Up' }

    it { should have_selector('h1', text: page_title) }
    it { should have_title(full_title(page_title)) }
  end
end
