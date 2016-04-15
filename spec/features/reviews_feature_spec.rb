require 'rails_helper'

feature 'reviewing' do
  let!(:user) { User.create(email: 'lo@renzo.com', password: 'lolsrenzo') }
  let!(:other_user) { User.create(email: 'other@user.com', password: 'otheruser') }

  let!(:kfc) { Restaurant.create(name: 'KFC', user_id: user.id) }

  context "user not signed in" do
    scenario 'guests can not leave a review' do
      visit '/restaurants'
      expect(page).not_to have_link 'Review KFC'
    end
  end

  context "user signed in" do
    before :each do
      helper_signin
      helper_leave_review(kfc,"so so", 3)
    end

    scenario 'inserting a review redirect to the main page and show the review' do
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'so so'
    end

    scenario 'review shows on the restaurant info page' do
      click_link 'KFC'
      expect(page).to have_content 'so so'
    end

    scenario 'user should only be allowed to leave a single review for restaurant' do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(current_path).to eq restaurants_path
      expect(page).to have_content 'You already have reviewed this restaurant'
    end

    scenario "restaurant rating should display the average from all reviews" do
      review2 = Review.create(thoughts: "out of this world", rating: 5, user_id: other_user.id, restaurant_id: kfc.id)
      visit restaurant_path(kfc.id)
      expect(page).to have_content "Average rating: ★★★★☆"
    end

  end

  context "deleting reviews" do
    scenario "user can delete their own review" do
      helper_signin
      review = Review.create(thoughts: "so so", rating: 3, user_id: user.id, restaurant_id: kfc.id)

      visit "/restaurants"
      click_link "KFC"
      click_link "Delete Review"
      expect(current_path).to eq restaurants_path
      expect(page).not_to have_content "so so"
    end

    context "cannot delete other users' reviews" do
      let!(:review) { Review.create(thoughts: "meh", rating: 1, user_id: other_user.id, restaurant_id: kfc.id) }

      before do
        helper_signin
      end

      scenario "prevents from deleting other users' reviews on user interface" do
        visit "/restaurants"
        click_link "KFC"
        expect(page).not_to have_link "Delete Review"
      end

      scenario "prevents from deleting other users' reviews via a delete request" do
        page.driver.submit :delete, review_path(review.id), {}
        expect(current_path).to eq restaurants_path
        expect(page).to have_content "meh"
        expect(page).to have_content "Feck off this is NOT your review your fat ass!"
      end
    end
  end
end
