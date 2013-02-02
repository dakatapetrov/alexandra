class Book
  attr_reader :isbn

  attr_accessor :id, 	    :title,      :series,
                :series_id, :author,     :year_published,
                :publisher, :page_count, :genres,
                :language,  :loan_period

  attr_writer :loanable, :free

  def initialize(id, isbn, title, series, series_id, author, year_published,
		publisher, page_count, genres, language, loan_period, loanable = true, free = true)

    raise InvalidISBN if not isbn.nil? and not is_valid_isbn13? isbn

    @id, @isbn, @title, @series, @series_id, @author, @year_published, @publisher,
    @page_count, @genres, @language, @loanable, @free, @loan_period = 
    id, isbn, title, series, series_id, author, year_published, publisher,
    page_count, genres, language, loanable, free, loan_period
  end

  def free?
    @free
  end

  def loanable?
    @loanable
  end

  def take
    @free = false
  end

  def return
    @free = true
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
