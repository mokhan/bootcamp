require "spec_helper"

describe MovieLibrary do
  let(:library) { MovieLibrary.new }
  let(:shawshank_redemption) { create_movie(title: "The Shawshank Redemption", studio: Studio::CastleRock, year_published: 1994) }
  let(:chasing_amy) { create_movie(title: "Chasing Amy", studio: Studio::MiramaxFilms, year_published: 1997) }
  let(:man_on_fire) { create_movie(title: "Man on Fire", studio: Studio::RegencyEnterprises, year_published: 2004) }

  let(:toy_story) { create_movie(title: "Toy Story", studio: Studio::Pixar, year_published: 1995) }
  let(:up) { create_movie(title: "Up", studio: Studio::Pixar, year_published: 2006) }
  let(:cars) { create_movie(title: "Cars", studio: Studio::Pixar, year_published: 2009) }
  let(:monsters_inc) { create_movie(title: "Monsters Inc.", studio: Studio::Pixar, year_published: 2001) }

  let(:fantasia) { create_movie(title: "Fantasia", studio: Studio::Disney, year_published: 1940) }
  let(:dumbo) { create_movie(title: "Dumbo", studio: Studio::Disney, year_published: 1941) }
  let(:pinocchio) { create_movie(title: "Pinocchio", studio: Studio::Disney, year_published: 1940) }

  let(:all_movies) { [shawshank_redemption, chasing_amy, man_on_fire, toy_story, up, cars, monsters_inc, fantasia, dumbo, pinocchio] }

  def create_movie(details)
    Movie.new(details)
  end

  context "when adding a movie to the library" do
    it "should increase the total number of movies in the library" do
      library.add(shawshank_redemption)
      library.add(chasing_amy)
      library.total_count.should == 2
    end

    it "should not allow duplicate movies into the library" do
      library.add(man_on_fire)
      library.add(man_on_fire)
      library.total_count.should == 1
    end

    it 'cannot add two movies that have the same title (logically the same)' do
      library.add(create_movie(:title => 'Old School'))
      library.add(create_movie(:title => 'Old School'))
      library.total_count.should == 1
    end
  end

  context 'Searching for movies' do
    before :each do
      all_movies.each { |x| library.add(x) }
    end

    it 'Can find all pixar movies' do
      results = library.find_all(Movie.produced_by(Studio::Pixar))
      results.count.should == 4
      results.should include(toy_story)
      results.should include(up)
      results.should include(cars)
      results.should include(monsters_inc)
    end

    it 'Can find all movies published by pixar or disney' do
      movies_by_pixar_or_disney = Movie.produced_by(Studio::Pixar).or(Movie.produced_by(Studio::Disney))
      results = library.find_all(movies_by_pixar_or_disney)
      results.count.should == 7
      results.should include(toy_story)
      results.should include(up)
      results.should include(cars)
      results.should include(monsters_inc)
      results.should include(fantasia)
      results.should include(dumbo)
      results.should include(pinocchio)
    end

    it 'Can find all movies not published by pixar' do
      results = library.find_all_movies_not_published_by_pixar
      results.length.should == 6
      results.should include(fantasia)
      results.should include(dumbo)
      results.should include(pinocchio)
      results.should include(shawshank_redemption)
      results.should include(chasing_amy)
      results.should include(man_on_fire)
    end

    it 'Can find all movies released after 2004' do
      results = library.find_all_movies_published_after_2004
      results.length.should == 2
      results.should include(up)
      results.should include(cars)
    end

    it 'Can find all movies released between 1982 and 2003 - Inclusive' do
      results = library.find_all_movies_between_1982_and_2003
      results.length.should == 4
      results.should include(shawshank_redemption)
      results.should include(chasing_amy)
      results.should include(toy_story)
      results.should include(monsters_inc)
    end
  end

  context 'Sorting movies' do
    before :each do
      all_movies.each { |x| library.add(x) }
    end

    it 'Sorts all movies by descending title' do
      expected_order = [up, toy_story, shawshank_redemption, pinocchio, monsters_inc, man_on_fire, fantasia, dumbo, chasing_amy, cars]
      results = library.sort_movies_by_title_descending
      results.should == expected_order
    end

    it 'Sorts all movies by ascending title' do
      expected_order = [cars, chasing_amy, dumbo, fantasia, man_on_fire, monsters_inc, pinocchio, shawshank_redemption, toy_story, up]
      results = library.sort_movies_by_title_ascending
      results.should == expected_order
    end

    it 'Sorts all movies by descending release date' do
      expected_order = [cars, up, man_on_fire, monsters_inc, chasing_amy, toy_story, shawshank_redemption, dumbo, fantasia, pinocchio ]
      results = library.sort_movies_by_descending_release_date
      results.should == expected_order
    end

    it 'Sorts all movies by ascending release date' do
      expected_order = [pinocchio, fantasia, dumbo, shawshank_redemption, toy_story, chasing_amy, monsters_inc, man_on_fire, up, cars]
      results = library.sort_movies_by_ascending_release_date
      results.should == expected_order
    end

    it 'Sorts all movies by preferred studios and release date ascending' do
      #rankings: Pixar, Disney, CastleRock, MiramaxFilms, RegenceyEnterprises
      expected_order = [ toy_story, monsters_inc, up, cars, fantasia, pinocchio, dumbo, shawshank_redemption, chasing_amy, man_on_fire]
      results = library.sort_movies_by_preferred_studios_and_release_date_ascending
      results.should == expected_order
    end
  end

  context "equality" do
    it "should not equal" do
      blah = create_movie(title: 'blah')
      huh = create_movie(title: 'huh')
      blah.should_not == huh
    end

    it "should equal" do
      huh1 = create_movie(title: 'huh')
      huh2 = create_movie(title: 'huh')
      huh1.should == huh2
    end
  end
end
