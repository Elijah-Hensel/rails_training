class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    case params[:filter]
    when 'upcoming'
      @movies = Movie.upcoming
    when 'recent'
      @movies = Movie.recent
    else
      @movies = Movie.released
    end
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit; end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: "#{@movie.title} succesfully updated!"
    else
      render :new
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "#{@movie.title} succesfully created!"
    else
      render :new
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, alert: "#{@movie.title} succesfully deleted!"
  end
end

private

def set_movie
  @movie = Movie.find_by!(slug: params[:id])
end

def movie_params
  params
    .require(:movie)
    .permit(
      :title,
      :description,
      :rating,
      :released_on,
      :total_gross,
      :director,
      :duration,
      :image_file_name,
      genre_ids: [],
    )
end
