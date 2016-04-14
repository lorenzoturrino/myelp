class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.has_reviewed? @restaurant
      flash[:notice] = 'You already have reviewed this restaurant'
      redirect_to '/restaurants'
    end
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.create(review_params)
    redirect_to '/restaurants'
  end

  def review_params
    parameters = params.require(:review).permit(:thoughts, :rating)
    parameters[:user_id] = current_user.id
    parameters
  end
end
