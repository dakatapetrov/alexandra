require 'date'
require 'bcrypt'
require './lib/catalog'

class Extension
  attr_reader :from_date, :to_date

  def initialize(from_date, to_date)
    @from_date, @to_date = from_date, to_date
  end
end

class Loan
  attr_reader :book_id, :from_date, :to_date, :extensions

  def initialize(book)
    @book_id    = book.id
    @from_date = Date.today
    @to_date = @from_date + book.rent_period
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
    if Date.today - @to_date <= 0 then 0
    else (Date.today - @to_date).to_i
    end
  end

  private

  def add_extension
    @extensions << Extension.new(@from_date, @to_date)
  end
end

class Member
  attr_reader :username, :email, :loans

  def initialize(username, email, password)
    @username, @email= username, email
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

  def change_email(email)
    @email = email
    @email_confirmed = false
  end

  def password?(password)
    @password == password
  end

  def change_password(password)
    @password = BCrypt::Password.create(password)
  end

  def take(book)
    @loans << Loan.new(book)
  end

  def return_book(book)
    @loans.select { |loan| loan.book_id == book.id }.first.return
  end

  def returned_loans
    @loans.select { |loan| loan.returned? }
  end

  def unreturned_loans
    @loans.select { |loan| not loan.returned? }
  end
end
