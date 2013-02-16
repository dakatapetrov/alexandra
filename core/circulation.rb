require 'date'
require 'bcrypt'
require './core/cataloging'

module Alexandra
  class Extension
    attr_reader :from_date, :to_date
  
    def initialize(from_date, to_date)
      @from_date, @to_date = from_date, to_date
    end
  end
  
  class Loan
    attr_reader :book_id, :from_date, :to_date, :extensions, :date_returned
  
    def initialize(book)
      @book_id    = book.id
      @from_date = Date.today
      @to_date = @from_date + book.loan_period
      @extensions = []
      @returned = false
    end
  
    def returned?
       @returned
    end
  
    def extend_by(days)
      @to_date += days
      add_extension
    end
  
    def extend_to(date)
      @to_date = date
      add_extension
    end
  
    def return
      @returned = true
      @date_returned = Date.today
      if @date_returned - @to_date <= 0 then 0
      else (@date_returned - @to_date).to_i
      end
    end
  
    private
  
    def add_extension
      @extensions << Extension.new(@from_date, @to_date)
    end
  end
  
  class Member
    attr_reader :id, :username, :email, :loans
  
    def initialize(id, username, email, password)
      @id, @username, @email = id, username, email
      @password = BCrypt::Password.create(password)
      @email_confirmed = false
      @loans = []
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
      @loans << Loan.new(book)
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
