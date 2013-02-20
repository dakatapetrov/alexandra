require 'date'
require 'bcrypt'

module Alexandra
  module Core
    class Loan
      attr_accessor :library_book_id, :from_date, :to_date, :date_returned

      attr_writer :returned

      def initialize(library_book_id, loan_period)
        @library_book_id    = library_book_id
        @from_date          = Date.today
        @to_date            = @from_date + loan_period
        @returned           = false
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
        @returned      = true
        @date_returned = Date.today

        if @date_returned - @to_date <= 0
          0
        else
          (@date_returned - @to_date).to_i
        end
      end
    end

    class Member
      attr_accessor :username, :email, :loans

      attr_reader :date_registred, :password

      def initialize(username, email, password)
        @username        = username.downcase
        @email           = email
        @password        = BCrypt::Password.create(password)
        @email_confirmed = false
        @date_registred  = Date.today
        @loans           = []
      end

      def email_confirmed?
        @email_confirmed
      end

      def confirm_email
        @email_confirmed = true
      end

      def email=(email)
        @email           = email
        @email_confirmed = false
      end

      def password?(password)
        @password == password
      end

      def password=(password)
        if password.class == BCrypt::Password
          @password = BCrypt::Password.new password
        else
          @password = BCrypt::Password.create(password)
        end
      end

      def take(library_book_id, loan_period)
        @loans << Loan.new(library_book_id, loan_period)
      end

      def return(library_book_id)
        @loans.select { |loan| loan.library_book_id == library_book_id and not loan.returned? }.
          first.return
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

      class UsernameTaken < RuntimeError
      end

      class EmailTaken < RuntimeError
      end

      def add(member)
        raise UsernameTaken if @members_list.any? { |m| m.username == member.username }
        raise EmailTaken    if @members_list.any? { |m| m.email == member.email }

        @members_list << member
      end

      def remove(username)
        @members_list.delete_if { |member| member.username== username }
      end

      private

      def list(attribute)
        @members_list.map(&attribute)
      end
    end
  end
end
