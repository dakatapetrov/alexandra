class Book
  attr_reader :isbn

  attr_accessor :id, 	    :title,      :series,
                :series_id, :author,     :year_published,
                :publisher, :page_count, :genres,
                :language,  :rent_period

  def initialize(id, isbn, title, series, series_id, author, year_published,
		publisher, page_count, genres, language, rent_period, can_take_home = true, is_free = true)

    raise InvalidISBN if not isbn.nil? and not is_valid_isbn13? isbn

    @id, @isbn, @title, @series, @series_id, @author, @year_published, @publisher,
    @page_count, @genres, @language, @can_take_home, @is_free, @rent_period = 
    id, isbn, title, series, series_id, author, year_published, publisher,
    page_count, genres, language, can_take_home, is_free, rent_period
  end

  def free?()
    @is_free
  end

  def can_take_home?()
    @can_take_home
  end

  def take()
    @is_free = false
  end

  def return()
    @is_free = true
  end

  def enable_taking_home()
    @can_take_home = true
  end

  def disable_taking_home()
    @can_take_home = false
  end

  def isbn=(isbn)
    raise InvalidISBN if not isbn.nil? and not is_valid_isbn13? isbn

    @isbn = isbn
  end

  class InvalidISBN < ArgumentError
  end

  private

  def isbn_checksum(isbn_string)
    digits = isbn_string.split(//).map(&:to_i)
    transformed_digits = digits.each_with_index.map do |digit, digit_index|
      digit_index.modulo(2).zero? ? digit : digit*3
    end
    sum = transformed_digits.reduce(:+)
  end
 
  def is_valid_isbn13?(isbn13)
    checksum = isbn_checksum(isbn13)
    checksum.modulo(10).zero?
  end
 
  def isbn13_checksum_digit(isbn12)
    checksum = isbn_checksum(isbn12)
    10 - checksum.modulo(10)
  end
end
