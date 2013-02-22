module Alexandra
  module Core
    class Book
      attr_accessor :library_id, :title,       :series,
                    :series_id,  :author,      :year_published,
                    :publisher,  :page_count,  :genre,
                    :language,   :loan_period, :isbn

      attr_writer :loanable, :free

     def initialize(library_id, title, author, loan_period)
        @library_id, @title,     @author, @loan_period    = library_id,   title, author, loan_period
        @loanable,   @free                                = true,         true
        @publisher,  @series_id, @genre , @year_published = nil,          nil,   nil,    nil
        @page_count, @language,  @series                  = nil,          nil,   nil
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
    end

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

      def empty?
        @books.empty?
      end

      def add(new_book)
        raise BookIDExists if @books.any? { |book| book.library_id == new_book.library_id }
        @books << new_book
      end

      def get(library_id)
        @books.select { |book| book.library_id == library_id }.first
      end

      def delete(library_id)
        @books.delete_if { |book| book.library_id == library_id }
      end

      %w[titles isbns authors publishers series genres].each do |name|
        if name == "series"
          define_method(name) { @books.map(&name.to_sym).flatten.compact.uniq }
        else
          define_method(name) { @books.map(&name.chop.to_sym).flatten.compact.uniq }
        end
      end

      def filter(criteria)
        Catalog.new @books.select { |book| criteria.met_by? book }
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

      class << self
        def title(string)
          Criteria.new { |book| book.title.downcase.include? string.downcase }
        end

        def series(string)
          Criteria.new { |book| book.series.to_s.downcase.include? string.downcase }
        end

        def author(string)
          Criteria.new { |book| book.author.downcase.include? string.downcase }
        end

        def isbn(isbn)
          Criteria.new { |book| book.isbn.to_s.downcase.include? isbn.to_s.downcase }
        end

        def any(string)
          title(string.to_s) | series(string.to_s) | author(string.to_s) | isbn(string.to_s)
        end
      end

      def |(other)
        Criteria.new { |book| self.met_by?(book) or other.met_by?(book) }
      end

      def &(other)
        Criteria.new { |book| self.met_by?(book) and other.met_by?(book) }
      end
    end
  end
end
