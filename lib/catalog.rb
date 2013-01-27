require './lib/book'

class Catalog
  def initialize(books = [])
    @books = books
  end

  def add(book)
    @books << book
  end

  def titles
    @books.map(&:title).compact.uniq
  end

  def isbns
    @books.map(&:isbn).compact.uniq
  end

  def series
    @books.map(&:series).compact.uniq
  end

  def authors
    @books.map(&:author).compact.uniq
  end

  def publishers
    @books.map(&:publisher).compact.uniq
  end

  def genres
    @books.map(&:genres).flatten.compact.uniq
  end
end
