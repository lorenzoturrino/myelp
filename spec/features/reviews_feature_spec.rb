require 'rails_helper'

feature 'reviewing' do
  let!(:user) { User.create(email: 'lo@renzo.com', password: 'lolsrenzo') }
  let!(:kfc) { Restaurant.create(name: 'KFC', user_id: user.id) }

  context "user not signed in" do
    scenario 'guests can not leave a review' do
      visit '/restaurants'
      expect(page).not_to have_link 'Review KFC'
    end

    scenario
  end

  context "user signed in" do
    before :each do
      helper_signin

      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

    scenario 'inserting a review redirect to the main page and show the review' do
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    scenario 'review shows on the restaurant info page' do
      click_link 'KFC'
      expect(page).to have_content('so so')
    end

    scenario 'user should only be allowed to leave a single review for restaurant' do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(current_path).to eq restaurants_path
      expect(page).to have_content 'You already have reviewed this restaurant'

    end

  end

end
