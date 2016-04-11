require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do

    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end

  end

  context 'at least one restaurant has beed added' do

    before do
      Restaurant.create(name: 'Pizzeria da Gianni')
    end

    scenario 'displays a restourant list' do
      expect(page).to have_content('Pizzeria da Gianni')
      expect(page).not_to have_content('No restaurants yet')
    end

  end

end
