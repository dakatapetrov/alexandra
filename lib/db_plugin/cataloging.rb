require 'dm-core'
require 'dm-migrations'

module Alexandra
  module DB

    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")

    class Book
      include DataMapper::Resource
      property :id,             Serial
      property :isbn,           Integer
      property :title,          String,  required: true
      property :series,         String
      property :series_id,      Integer
      property :author,         String,  required: true
      property :year_published, String
      property :publisher,      String
      property :page_count,     Integer
      property :genre,          String
      property :language,       String
      property :loan_period,    Integer, required: true
      property :loanable,       Boolean, required: true, default: true
      property :free,           Boolean, required: true, default: true
    end

    DataMapper.finalize.auto_upgrade!

  end
end
