require 'helpers'

class MovieLibrary
  include Helpers

  def initialize(movies = [])
    @movies = movies
  end

  def add(movie)
    exists = false
    @movies.each do |m|
      exists = true if movie.title == m.title
    end
    @movies.push(movie) if exists == false
  end

  def total_count
    @movies.size
  end

  def find_all(criteria)
    @results = []
    @movies.each do |movie|
      @results.push(movie) if criteria.call(movie)
    end
    @results
  end

  def find_all_movies_not_published_by_pixar()
    matcher = Movie.not.produced_by(Studio::Pixar)
    find_all(matcher)
  end

  def find_all_movies_published_after_2004()
    matcher = lambda { |m| m.year_published > 2004 }
    find_all(matcher)
  end
  
  def find_all_movies_between_1982_and_2003()
    matcher = lambda { |m| m.year_published >= 1982 && m.year_published <= 2003 }
    find_all(matcher)
  end
  
  def sort_movies_by_title_descending()
    @movies.sort {|a,b| b.title <=> a.title}
  end
  
  def sort_movies_by_title_ascending()
    @movies.sort {|a,b| a.title <=> b.title}
  end
  
  def sort_movies_by_descending_release_date()
    @movies.sort {|a,b| b.year_published <=> a.year_published}
  end
  
  def sort_movies_by_ascending_release_date()
    @movies.sort {|a,b| a.year_published <=> b.year_published}
  end
  
  def sort_movies_by_preferred_studios_and_release_date_ascending()
    preferred_order = [Studio::Pixar, Studio::Disney, Studio::CastleRock, Studio::MiramaxFilms, Studio::RegencyEnterprises]
    sorted = @movies.sort do |movie1,movie2|  
      new_order = preferred_order.find_index(movie1.studio) <=> preferred_order.find_index(movie2.studio)
      if(new_order==0)
        movie1.year_published <=> movie2.year_published
      else
        new_order
      end
    end
  end

  def each
    # @movies.count.times do |n|
    #   yield @movies[n]
    # end

    # n = 0
    # loop do
    #   current = @movies[n]
    #   puts current
    #   return unless current
    #   yield current
    #   n += 1
    # end

    # for x in @movies
    #   yield x
    # end

    # i = 0
    # current = @movies[i]
    # while current do
    #   yield current
    #   current = @movies[i]
    #   i+=1
    # end

    # i = 0
    #   until i == @movies.count do
    #     yield @movies[i]
    #     i +=1
    #   end
    #       
    #i =0
    #yield @movies[i]; i+=1 until @movies.count==i
    #      

    # puts "blah" while true
    @movies.each do |movie|
      yield movie
    end
  end
end
