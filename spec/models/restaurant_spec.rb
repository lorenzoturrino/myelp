require 'rails_helper'

describe Restaurant, type: :model do

  it { is_expected.to have_many(:reviews).dependent :destroy }

  it { is_expected.to belong_to(:user) }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).not_to be_valid
    expect(restaurant).to have(1).error_on(:name)
  end

  it "is not valid unless it has a unique name" do
    Restaurant.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns that rating' do
        restaurant = Restaurant.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq "★★★★☆"
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        lolrenzo = User.create(email: 'lo@renzo.com', password: 'lolsrenzo')
        otherguy = User.create(email: 'other@user.com', password: 'otheruser')
        restaurant = Restaurant.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 1, user_id: lolrenzo.id)
        restaurant.reviews.create(rating: 5,user_id: otherguy.id)

        expect(restaurant.average_rating).to eq "★★★☆☆"
      end
    end
  end
end
