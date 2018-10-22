require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  let(:base_title) { 'Chubakka' }

  subject { page }

  describe 'signup page' do
    before { visit signup_path }

    it { should have_content('Sign Up') }
    it { should have_title("#{base_title} | Sign Up") }
  end
end
