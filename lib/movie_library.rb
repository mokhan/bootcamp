require 'helpers'

class MovieLibrary
  include Enumerable

  def initialize(movies = [])
    @movies = movies
  end

  def add(movie)
    @movies.push(movie) unless include?(movie)
  end

  def total_count
    @movies.size
  end

  def each
    @movies.each do |movie|
      yield movie
    end
  end

  def find_all_movies_by_pixar
    find_all do |movie|
      movie.studio == Studio::Pixar
    end
  end

  def find_all_movies_by_pixar_or_disney
    movies_by_disney = find_all do |movie|
      movie.studio == Studio::Disney
    end
    find_all_movies_by_pixar + movies_by_disney
  end

  def find_all_movies_not_published_by_pixar
    @movies - find_all_movies_by_pixar
  end

  def find_all_movies_published_after_2004
    find_all do |movie|
      movie.year_published > 2004
    end
  end

  def find_all_movies_between_1982_and_2003
    find_all do |movie|
      movie.year_published >= 1982 && movie.year_published <= 2003
    end
  end

  def sort_movies_by_title_descending
    @movies.sort do |x, y|
      x.title <=> y.title
    end
  end

  def sort_movies_by_title_ascending
    sort_movies_by_title_descending.reverse
  end

  def sort_movies_by_descending_release_date
    sort_movies_by_ascending_release_date.reverse
  end

  def sort_movies_by_ascending_release_date
    @movies.sort do |x, y|
      x.year_published <=> y.year_published
    end
  end

  def sort_movies_by_preferred_studios_and_release_date_ascending
    rankings = [Studio::Pixar, Studio::Disney, Studio::CastleRock, Studio::MiramaxFilms, Studio::RegencyEnterprises]
    @movies.sort do |x, y|
      result = rankings.find_index(x.studio) <=> rankings.find_index(y.studio)
      result == 0 ? x.year_published <=> y.year_published : result
    end
  end
end
