require_relative 'administration'
require_relative 'cataloging'
require_relative 'circulation'
require_relative '../core/core'

module Alexandra
  module DB
    class DBMap
      class << self
        def load(object)
          case object
          when Alexandra::Core::Library       then load_library       object
          when Alexandra::Core::Book          then load_book          object
          when Alexandra::Core::Member        then load_member        object
          when Alexandra::Core::Administrator then load_administrator object
          end
        end

        def load_library(library)
          db_library = Library.get(1)
          return false if not db_library

          library.name = db_library.name
          library.fine = db_library.fine
          true
        end

        def load_book(book)
          db_book = Book.get(book.id)
          return false if not db_book

          book.title          = db_book.title
          book.isbn           = db_book.isbn
          book.series         = db_book.series
          book.series_id      = db_book.series_id
          book.author         = db_book.author
          book.year_published = db_book.year_published
          book.publisher      = db_book.publisher
          book.page_count     = db_book.page_count
          book.genre          = db_book.genre
          book.language       = db_book.language
          book.loan_period    = db_book.loan_period
          book.loanable       = db_book.loanable
          book.free           = db_book.free
          true
        end

        def load_administrator(admin)
          db_admin = Administrator.get(admin.id)
          return false if not db_admin

          admin.username = db_admin.username
          admin.password = db_admin.password
          true
        end

        def load_member(member)
          db_member = Member.get(member.id)
          return false if not db_member

          member.username = db_member.username
          member.email    = db_member.email
          member.password = db_member.password
          load_loans member.loans, member.id
          member.confirm_email if db_member.email_confirmed
          true
        end

        def load_loans(loans, member_id)
          return if not Loan.all(:member_id => member_id)
          Loan.all(:member_id => member_id).each do |db_loan|
            loan = Alexandra::Core::Loan.new db_loan.book_id, 0

            loan.from_date     = db_loan.from_date
            loan.to_date       = db_loan.to_date
            loan.date_returned = db_loan.date_returned
            loan.returned      = db_loan.returned

            loans << loan
          end
        end

        def save(object)
          case object
          when Alexandra::Core::Library       then save_library       object
          when Alexandra::Core::Book          then save_book          object
          when Alexandra::Core::Member        then save_member        object
          when Alexandra::Core::Administrator then save_administrator object
          end
        end

        def save_book(book)
          if Book.get(book.id) then db_book = Book.get(book.id)
          else db_book = Book.new
          end

          set_attributes(book, db_book)

          db_book.save
        end

        #def save_member(member)
        #  if Member.get(member.id) then db_member = Member.get(member.id)
        #  else db_member = Member.new
        #  end

        #  set_attributes(member, db_member)
        #  db_member.save
        #end

        def save_administrator(administrator)
          if Administrator.get(administrator.id) then db_administrator = Administrator.get(administrator.id)
          else db_administrator = Administrator.new
          end

          set_attributes administrator, db_administrator
          db_administrator.save
        end

        private

        def set_attributes(object1, object2)
          object1.instance_variables.each do |variable|
            object2.attribute_set(variable.to_s.gsub(/\@/, "").to_sym, object1.instance_variable_get(variable))
          end
        end

        #def get_attributes(object1, object2)
        #  object2.instance_variables.each do |variable|
        #    object1.instance_variable_set(variable, object2.instance_variable_get(variable))
        #  end
        #end
      end
    end
  end
end
