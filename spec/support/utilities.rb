include ApplicationHelper

def valid_signin(user)
  fill_in 'email',    with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign In'
end

def right_layout_links
  visit root_path
  click_link 'About'
  expect(page).to have_title(full_title('About Us'))
  click_link 'Help'
  expect(page).to have_title(full_title('Help'))
  click_link 'Contact'
  expect(page).to have_title(full_title('Contact'))
  click_link 'Home'
  click_link 'Sign Up Now!'
  expect(page).to have_title(full_title('Sign Up'))
  click_link 'сhubakka'
  expect(page).to have_title(full_title(''))
end

def fill_signup_fields
  fill_in 'Name',         with: 'Test User'
  fill_in 'Email',        with: 'user@test.com'
  fill_in 'Password',     with: '12345678'
  fill_in 'Confirmation', with: '12345678'
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end