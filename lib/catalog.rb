require './lib/book'

class Catalog
  include Enumerable

  def initialize(books = [])
    @books = books
  end

  class BookIDExists < RuntimeError
  end

  def each(&block)
    @books.each(&block)
  end

  def add(book)
    raise BookIDExists if @books.any? { |catalog_book| catalog_book.id == book.id }
    @books << book
  end

  def edit(id)
    @books.select { |book| book.id == id }.first
  end

  def delete(id)
    @books.delete_if { |book| book.id == id }
  end

  def titles
    list_uniq :title
  end

  def isbns
    list_uniq :isbn
  end

  def series
    list_uniq :series
  end

  def authors
    list_uniq :author
  end

  def publishers
    list_uniq :publisher
  end

  def genres
    list_uniq :genres
  end

  def filter(criteria)
    Catalog.new @books.select { |book| criteria.met_by? book }
  end

  private

  def list_uniq(attribute)
    @books.map(&attribute).flatten.compact.uniq
  end
end

class Criteria
  attr_reader :matcher

  def initialize(&block)
    @matcher = block
  end

  def met_by?(book)
    @matcher.call book 
  end

  def self.title(title)
    Criteria.new { |book| book.title == title }
  end

  def self.series(series)
    Criteria.new { |book| book.series == series }
  end

  def self.author(author)
    Criteria.new { |book| book.author == author }
  end

  def self.isbn(isbn)
    Criteria.new { |book| book.isbn == isbn }
  end

  def |(other)
    Criteria.new { |book| self.met_by?(book) or other.met_by?(book) }
  end

  def &(other)
    Criteria.new { |book| self.met_by?(book) and other.met_by?(book) }
  end
end
