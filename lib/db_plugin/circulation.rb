require 'data_mapper'
require 'date'
require 'bcrypt'

module Alexandra
  module DB

    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")
    
    class Loan
      include DataMapper::Resource

      property :id,            Serial
      property :from_date,     Date,    required: true, default: Date.today
      property :to_date,       Date,    required: true
      property :returned,      Boolean, required: true, default: false
      property :date_returned, Date

      belongs_to :member
      belongs_to :book
    end
    
    class Member
      include DataMapper::Resource

      property :id,              Serial
      property :username,        String,     required: true, unique:  true
      property :email,           String,     required: true, unique:  true
      property :email_confirmed, Boolean,    required: true, default: false
      property :password,        BCryptHash

      has n, :loans
    end
    
    DataMapper.finalize.auto_upgrade!

  end
end
