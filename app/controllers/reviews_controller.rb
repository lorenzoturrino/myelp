class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.has_reviewed? @restaurant
      flash[:notice] = 'You already have reviewed this restaurant'
      redirect_to restaurants_path
    end
    @review = Review.new
  end

  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def destroy
    puts "params: #{params}\n revs:"
    Review.all.each {|rev| puts rev.id}
    review = Review.find(params[:id])
    if current_user.id == review.user_id
      review.destroy
    else
      flash[:notice] = "Feck off this is NOT your review your fat ass!"
    end
    redirect_to restaurants_path
  end

  def review_params
    parameters = params.require(:review).permit(:thoughts, :rating)
    parameters[:user_id] = current_user.id
    parameters
  end
end
