class By
  class << self
    def method_missing(field, *arguments)
      if arguments.any?
        rankings = arguments.first
        rank(rankings, field)
      else
        SortBy.new(field)
      end
    end

    def rank(rankings, field)
      RankedComparer.new(rankings, field)
    end
  end

  class SortBy
    include Comparer

    def initialize(field)
      @field = field
    end

    def compare(x, y)
      x.public_send(@field) <=> y.public_send(@field)
    end
  end
end

