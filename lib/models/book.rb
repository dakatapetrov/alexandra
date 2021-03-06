module Alexandra
  module DB
    class Book
      include DataMapper::Resource
      property :id,             Serial
      property :library_id,     Integer, required: true, unique:  true
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
  end
end
