module Alexandra
  module Core
    class Book
      attr_accessor :id, 	:title,       :series,
                    :series_id, :author,      :year_published,
                    :publisher, :page_count,  :genre,
                    :language,  :loan_period, :isbn

      attr_writer :loanable, :free

     def initialize(id, title, author, loan_period)
        @id, @title, @author, @loan_period = id, title, author, loan_period
        @loanable, @free            = true, true
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

      def add(book)
        raise BookIDExists if @books.any? { |catalog_book| catalog_book.id == book.id }
        @books << book
      end

      def get(id)
        @books.select { |book| book.id == id }.first
      end

      def delete(id)
        @books.delete_if { |book| book.id == id }
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

        def isbn(string)
          Criteria.new { |book| book.isbn.to_s.downcase.include? string.downcase }
        end

        def any(string)
          title(string) | series(string) | author(string) | isbn(string)
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
