require 'spec_helper'
require 'capybara/rails'


feature "visitor signs up" do
  scenario "with valid details" do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Password"
      fill_in 'Password Confirmation', :with => "Password"
      click_button 'Sign Up'
    end
    expect(page).to have_content("TomWissy") # user is logged in after signup
  end

  scenario "with invalid details" do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "invalidemail"
      fill_in 'Password', :with => "short"
      fill_in 'Password Confirmation', :with => "nonmatchingconfirmation"
      click_button 'Sign Up'
    end
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Email is invalid")
    expect(page).to have_content("Password is too short (minimum is 7 characters)")
  end

  scenario "with non-unique email and/or username" do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "password"
      fill_in 'Password Confirmation', :with => "password"
      click_button 'Sign Up'
    end
    click_link "Log Out"
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "password"
      fill_in 'Password Confirmation', :with => "password"
      click_button 'Sign Up'
    end
    expect(page).to have_content("Username has already been taken")
    expect(page).to have_content("Email has already been taken")
  end   

  scenario "with no details given" do
    visit '/'
    within '#signup' do
      click_button 'Sign Up'
    end
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Email is invalid")
    expect(page).to have_content("Password is too short (minimum is 7 characters)")
    expect(page).to have_content("Username can't be blank")
    expect(page).to have_content("Email can't be blank")
  end
end

feature "User logs outs" do
  scenario "when logged in" do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Password"
      fill_in 'Password Confirmation', :with => "Password"
      click_button 'Sign Up'
    end
    click_link 'Log Out'
    expect(page).to have_content("Log out successful.")
  end
end

feature "User logs in" do

  before(:each) do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Password"
      fill_in 'Password Confirmation', :with => "Password"
      click_button 'Sign Up'
    end
    click_link 'Log Out'
  end

  scenario "with valid details" do
    click_link 'Log In'
    within '#login' do
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Password"
    end
    click_button 'Log In'
    expect(page).to have_content("TomWissy")
  end

  scenario "with invalid details" do
    click_link 'Log In'
    within '#login' do
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Pissyword"
    end
    click_button 'Log In'
    expect(page).to have_content("Password and/or email incorrect.")
  end

end


feature "User views Leaderboard" do

  before(:each) do
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "TomWissy"
      fill_in 'Email', :with => "tom@gmail.com"
      fill_in 'Password', :with => "Password"
      fill_in 'Password Confirmation', :with => "Password"
      click_button 'Sign Up'
    end
    click_link 'Log Out'
    visit '/'
    within '#signup' do
      fill_in 'Username', :with => "NeilAtkins"
      fill_in 'Email', :with => "neil@gmail.com"
      fill_in 'Password', :with => "Password"
      fill_in 'Password Confirmation', :with => "Password"
      click_button 'Sign Up'
    end
  end

  scenario "when logged in" do
    click_link 'View Leaderboard'
    expect(page).to have_content("TomWissy")
    expect(page).to have_content("NeilAtkins")
  end
end
