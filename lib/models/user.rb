module Alexandra
  module DB
    class Loan
      include DataMapper::Resource

      property :id,              Serial
      property :library_book_id, Integer, required: true
      property :from_date,       Date,    required: true, default: Date.today
      property :to_date,         Date,    required: true
      property :returned,        Boolean, required: true, default: false
      property :date_returned,   Date

      belongs_to :member
      belongs_to :book
    end

    class Member
      include DataMapper::Resource

      property :id,              Serial
      property :username,        String,     required: true, unique:  true
      property :email,           String,     required: true, unique:  true
      property :password,        BCryptHash, required: true
      property :email_confirmed, Boolean,    required: true, default: false
      property :date_registred,  Date,       required: true, default: Date.today

      has n, :loans
    end
  end
end