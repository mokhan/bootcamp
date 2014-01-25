class MoviesController < ApplicationController
  before_filter :authenticate_admins, except: [:index]

  def index
    @movies = Movie.all
    session[:user_id] = 1
  end

  def new
    @movie = Movie.new
  end
  
  def create
    @movie = Movie.new(movie_params)
    @movie.save
    redirect_to movies_path, notice: 'Yay!'
  end

  private
  
  def movie_params
    params.require(:movie).permit(:title)
  end

  def authenticate_admins
    redirect_to movies_path if session[:user_id].nil?
  end
end
