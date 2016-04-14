require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    let!(:kfc) { Restaurant.create(name:'KFC') }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    before :each do
      helper_signup
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

  end

  context 'viewing detailed restaurant info' do
    let!(:kfc) { Restaurant.create(name:'KFC') }

    scenario 'lets a user view info about a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do
    let!(:user) { User.create(email: 'lo@renzo.com', password: 'lolsrenzo') }
    let!(:kfc) { Restaurant.create(name: 'KFC', user_id: user.id) }

    scenario 'lets a user edit a restaurant they created' do
      helper_signin
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'prevents a user from editing restaurants they did not create' do
      User.create(email: 'other@user.com', password: 'otheruser')
      helper_signin(email: 'other@user.com', password: 'otheruser')
      visit '/restaurants'
      expect(page).not_to have_link 'Edit KFC'
    end
  end

  context 'deleting restaurants' do
    let!(:user) { User.create(email: 'lo@renzo.com', password: 'lolsrenzo') }
    let!(:kfc) { Restaurant.create(name: 'KFC', user_id: user.id) }

    scenario 'lets a user remove a restaurant they created' do
      helper_signin
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'prevents a user from removing restaurants they did not create' do
      User.create(email: 'other@user.com', password: 'otheruser')
      helper_signin(email: 'other@user.com', password: 'otheruser')
      visit '/restaurants'
      expect(page).not_to have_link 'Delete KFC'
    end
  end

end
