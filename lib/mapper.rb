require_relative 'db_plugin/db_plugin'
require_relative 'core/core'

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

        db_to_core db_library, library

        library
      end

      def load_book(id)
        db_book = DB::Book.get(id)
        return nil if not db_book

        book = Core::Book.new nil, nil, nil, nil

        db_to_core db_book, book

        book
      end

      def load_administrator(id)
        db_admin = DB::Administrator.get(id)
        return nil if not db_admin

        admin = Core::Administrator.new nil, "", nil

        db_to_core db_admin, admin

        admin
      end

      def load_member(id)
        db_member = DB::Member.get(id)
        return nil if not db_member

        member = Core::Member.new nil, "", nil, nil

        db_to_core db_member, member

        member.loans    = load_loans id

        member
      end

      def load_loans(member_id)
        loans = []

        return if not DB::Loan.all(:member_id => member_id)
        DB::Loan.all(:member_id => member_id).each do |db_loan|
          loan = Core::Loan.new db_loan.book_id, 0

          db_to_core db_loan, loan

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

      def save_library(library)
        db_library = DB::Library.get(1)
        db_library = DB::Library.new if not db_library

        core_to_db library, db_library

       db_library.save
      end

      def save_book(book)
        db_book = DB::Book.get(book.id)
        db_book = DB::Book.new if not db_book

        core_to_db book, db_book

        db_book.save
      end

      def save_member(member)
        db_member = DB::Member.get(member.id)
        db_member = DB::Member.new if not db_member

        core_to_db member, db_member
        db_member.save

        member.loans.each { |loan| save_loan loan, member.id }
      end

      def save_loan(loan, member_id)
        db_loan = DB::Loan.last(book_id: loan.book_id, member_id: member_id)
        db_loan = DB::Loan.new if not db_loan

        core_to_db loan, db_loan
        db_loan.book   = DB::Book.get(loan.book_id)
        db_loan.member = DB::Member.get(member_id)
        db_loan.save
      end

      def save_administrator(administrator)
        db_administrator = DB::Administrator.get(administrator.id)
        db_administrator = DB::Administrator.new if not db_administrator

        core_to_db administrator, db_administrator
        db_administrator.save
      end

      private

      def core_to_db(core_object, db_object)
        core_object.instance_variables.each do |variable|
          db_object.attribute_set variable.to_s.gsub(/\@/, "").to_sym,
                                  core_object.instance_variable_get(variable)
        end
      end

      def db_to_core(db_object, core_object)
        core_object.instance_variables.each do |variable|
          core_object.instance_variable_set variable,
                                            db_object.attribute_get(variable.to_s.gsub(/\@/, "").to_sym)
        end
      end
    end
  end
end
