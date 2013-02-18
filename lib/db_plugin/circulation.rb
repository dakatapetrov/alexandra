require 'data_mapper'
require_relative '../core/circulation'
require_relative 'cataloging'

module Alexandra
  module DB

    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")
    
    class Loan < Alexandra::Core::Loan
      include DataMapper::Resource
      property :id, Serial
      property :book_id, Integer, :required => true
      property :from_date, Date, :required => true, default: Date.today
      property :to_date, Date, :required => true, default: Date.today
      property :returned, Boolean, :required => true, :default => false
      property :date_returned, Date
      belongs_to :member
    end
    
    class Member < Alexandra::Core::Member
      include DataMapper::Resource
      property :id, Serial
      property :username, String, :required => true, :unique => true
      property :email, String, :required => true, :unique => true
      property :email_confirmed, Boolean, :required => true, :default => false
      property :password, BCryptHash
      has n, :loans, :through => Resource
    end
    
    class Members < Alexandra::Core::Members
      def initialize(members = Member.all)
        @members = members
      end
    
      def remove(id)
        Member.get(id).destroy
      end

      def save
        @members.each { |member| member.save }
      end
    end

    DataMapper.finalize.auto_upgrade!

    loan = Loan.new
    loan.book_id = 2
    loan.member = Member.get(1)
    loan.save

  end
end
