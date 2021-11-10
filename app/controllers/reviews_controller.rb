class ReviewsController < ApplicationController
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    if @review.save
      redirect_to movie_reviews_url(@movie),
                  notice: 'Thank you for your review!'
    else
      render :new
    end
  end

  def edit
    @review = @movie.reviews.find(params[:id])
  end

  def update
    @review = @movie.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path(@movie),
                  notice: 'Review succesfully updated!'
    else
      render :new
    end
  end

  def destroy
    @review = @movie.reviews.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_url, alert: 'Review succesfully deleted!'
  end

  private

  def review_params
    params.require(:review).permit(:name, :stars, :comment)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end