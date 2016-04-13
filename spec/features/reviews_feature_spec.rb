require 'rails_helper'

feature 'reviewing' do
  let!(:kfc) { Restaurant.create name: 'KFC' }

  feature 'allows users to leave a review using a form' do

    before(:each) do
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

  end

end
