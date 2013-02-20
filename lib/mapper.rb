require_relative 'administration'
require_relative 'cataloging'
require_relative 'circulation'
require_relative '../core/core'

module Alexandra
  class Mapper
    class << self
      def load(hash)
        case
        when hash[:library]       then load_library
        when hash[:book]          then load_book          hash[:book]
        when hash[:member]        then load_member        hash[:member]
        when hash[:administrator] then load_administrator hash[:administrator]
        end
      end

      def load_library
        db_library = DB::Library.get(1)
        return nil if not db_library

        library = Core::Library.new nil, nil

        library.name = db_library.name
        library.fine = db_library.fine

        library
      end

      def load_book(id)
        db_book = DB::Book.get(id)
        return nil if not db_book

        book = Core::Book.new nil, nil, nil, nil

        book.id             = db_book.id
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

        book
      end

      def load_administrator(id)
        db_admin = DB::Administrator.get(id)
        return nil if not db_admin

        admin = Core::Administrator.new nil, "", nil

        admin.id       = db_admin.id
        admin.username = db_admin.username
        admin.password = db_admin.password

        admin
      end

      def load_member(id)
        db_member = DB::Member.get(id)
        return nil if not db_member

        member = Core::Member.new nil, "", nil, nil

        member.id       = db_member.id
        member.username = db_member.username
        member.email    = db_member.email
        member.password = db_member.password
        member.loans    = load_loans id
        member.confirm_email if db_member.email_confirmed

        member
      end

      def load_loans(member_id)
        loans = []

        return if not DB::Loan.all(:member_id => member_id)
        DB::Loan.all(:member_id => member_id).each do |db_loan|
          loan = Core::Loan.new db_loan.book_id, 0

          loan.from_date     = db_loan.from_date
          loan.to_date       = db_loan.to_date
          loan.date_returned = db_loan.date_returned
          loan.returned      = db_loan.returned

          loans << loan
        end

        loans
      end

      def save(object)
        case object
        when Core::Library       then save_library       object
        when Core::Book          then save_book          object
        when Core::Member        then save_member        object
        when Core::Administrator then save_administrator object
        end
      end

      def save_book(book)
        if DB::Book.get(book.id) then db_book = DB::Book.get(book.id)
        else db_book = DB::Book.new
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
        if DB::Administrator.get(administrator.id) then db_administrator = DB::Administrator.get(administrator.id)
        else db_administrator = DB::Administrator.new
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
