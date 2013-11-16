class Movie
  attr_reader :title, :studio, :year_published

  def initialize(attributes)
    @title, @studio, @year_published = attributes.values_at(:title, :studio, :year_published)
  end

  def ==(other)
    title == other.title
  end

  def self.produced_by(studio)
    lambda { |movie| movie.studio == studio }
  end
end

class Proc
  def or(another_proc)
    lambda { |*arguments| self.call(*arguments) || another_proc.call(*arguments)  }
  end

  def not
    lambda { |*arguments| !self.call(*arguments) }
  end
end
