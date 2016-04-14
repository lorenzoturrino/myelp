require 'rails_helper'
require_relative 'web_helpers'

feature 'restaurants' do
  before do
    sign_up_1
  end
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end
    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'promp user to fill out a form, then displays the newest restaurant' do
      # sign_in_1
      create_restaurant('KFC')
      expect(page).to have_content 'KFC'
      p User.first
      p Restaurant.first
      expect(Restaurant.first.user.email).to eq 'test@example.com'
      expect(current_path).to eq '/restaurants'
    end

    context 'user is not signed in' do
      scenario 'user cannot create restaurant when not signed in' do
        click_link 'Sign out'
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
        expect(page).not_to have_content 'Create Restaurant'
      end
    end


    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        create_restaurant('kf')
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    scenario 'let a user edit a restaurant' do
      create_restaurant('KFC')
     visit '/restaurants'
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(current_path).to eq '/restaurants'
    end

    scenario 'will not let user edit restaurant they did not create' do
      create_restaurant('KFC')
      click_link('Sign out')
      sign_up_2
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).not_to have_button 'Update Restaurant'
    end
  end

  context 'deleting restaurants' do


    scenario 'removes a restaurant when a user clicks a delete link' do
      create_restaurant('KFC')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'will not let user delete restaurant they did not create' do
      create_restaurant('KFC')
      click_link('Sign out')
      sign_up_2
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'Restaurant deleted successfully'
    end
  end
end
