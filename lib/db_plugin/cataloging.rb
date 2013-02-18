require 'data_mapper'
require_relative '../core/cataloging'

module Alexandra
  module DB
  
    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")

  class Book < Alexandra::Core::Book
    include DataMapper::Resource
    property :id, Serial
    property :isbn, Text 
    property :title, Text
    property :series, Text
    property :series_id, Integer
    property :author, Text
    property :year_published, Integer 
    property :publisher, Text
    property :page_count, Integer, :required => true
    property :genres, Text
    property :language, Text
    property :loan_period, Integer
    property :loanable, Boolean, :required => true, :default => true
    property :free, Boolean, :required => true, :default => false
  end
  
  class Catalog < Alexandra::Core::Catalog
    def initialize(books = Book.all)
      @books = books
    end

    def add(book)
      @books << book
    end
  
    def save
      @books.each { |book| book.save }
    end
  
    def get(id)
      Book.get(id)
    end
  
    def delete(id)
      Book.get(id).destroy
    end
  end
  
  class Criteria < Alexandra::Core::Criteria
  end
  
  DataMapper.finalize.auto_upgrade!

  end
end
