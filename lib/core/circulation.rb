require 'date'
require 'bcrypt'
require './lib/core/cataloging'

module Alexandra
  module Core
    class Loan
      attr_accessor :book_id, :from_date, :to_date, :extensions, :returned, :date_returned
    
      def self.create(book)
        loan = Loan.new

        loan.book_id    = book.id
        loan.from_date = Date.today
        loan.to_date = Date.today + book.loan_period
        loan.extensions = []
        loan.returned = false

        loan
      end
    
      def returned?
         @returned
      end
    
      def extend_by(days)
        @to_date += days
      end
    
      def extend_to(date)
        @to_date = date
      end
    
      def return
        @returned = true
        @date_returned = Date.today
        if @date_returned - @to_date <= 0 then 0
        else (@date_returned - @to_date).to_i
        end
      end
    end
    
    class Member
      attr_accessor :id, :username, :email, :loans
    
      def self.create(id, username, email, password)
        member = Member.new

        member.id, member.username, member.email = id, username, email
        member.password = password
        member.loans = []

        member
      end
    
      def email_confirmed?
        @email_confirmed
      end
    
      def confirm_email
        @email_confirmed = true
      end
    
      def email=(email)
        @email = email
        @email_confirmed = false
      end
    
      def password?(password)
        @password == password
      end
    
      def password=(password)
        @password = BCrypt::Password.create(password)
      end
    
      def take(book)
        @loans << Loan.create(book)
      end
    
      def return(book)
        @loans.select { |loan| loan.book_id == book.id and not loan.returned? }.first.return
      end
    
      def returned_loans
        @loans.select { |loan| loan.returned? }
      end
    
      def unreturned_loans
        @loans.select { |loan| not loan.returned? }
      end
    end
    
    class Members
      include Enumerable
    
      def initialize(members_list = [])
        @members_list = members_list
      end
    
      def each(&block)
        @members_list.each(&block)
      end
    
      def usernames
        list :username
      end
    
      def emails
        list :email
      end
    
      def add(member)
        @members_list << member
      end
    
      def remove(member_id)
        @members_list.delete_if { |member| member_id == member.id }
      end
    
      private
    
      def list(attribute)
        @members_list.map(&attribute)
      end
    end
  end
end
