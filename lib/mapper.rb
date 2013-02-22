module Alexandra
  class Mapper
    class << self
      def load(hash)
        case
        when hash[:library]       then load_library
        when hash[:book]          then load_book          hash[:book]
        when hash[:member]        then load_member        hash[:member]
        when hash[:administrator] then load_administrator hash[:administrator]
        when hash[:catalog]       then load_catalog
        end
      end

      def save(object)
        case object
        when Core::Library       then save_library       object
        when Core::Book          then save_book          object
        when Core::Member        then save_member        object
        when Core::Administrator then save_administrator object
        end
      end

      def delete(hash)
        case
        when hash[:book]          then delete_book          hash[:book]
        when hash[:member]        then delete_member        hash[:member]
        when hash[:administrator] then delete_administrator hash[:administrator]
        end
      end

      private

      def load_library
        db_library = DB::Library.get(1)
        return nil if not db_library

        library = Core::Library.new nil, nil

        db_to_core db_library, library

        library
      end

      def load_book(library_id)
        db_book = DB::Book.last(library_id: library_id)
        return nil if not db_book

        book = Core::Book.new nil, nil, nil, nil

        db_to_core db_book, book

        book
      end

      def load_administrator(username)
        db_admin = DB::Administrator.last(username: username)
        return nil if not db_admin

        admin = Core::Administrator.new "", nil

        db_to_core db_admin, admin

        admin
      end

      def load_member(username)
        db_member = DB::Member.last(username: username)
        return nil if not db_member

        member = Core::Member.new "", nil, nil

        db_to_core db_member, member

        member.loans    = load_loans db_member.id

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

      def load_catalog
        Core::Catalog.new DB::Book.all.map { |book| load_book book.library_id }
      end

      def save_library(library)
        db_library = DB::Library.get(1)
        db_library = DB::Library.new if not db_library

        core_to_db library, db_library

       db_library.save
      end

      def save_book(book)
        db_book = DB::Book.last(library_id: book.library_id)
        db_book = DB::Book.new if not db_book

        core_to_db book, db_book

        db_book.save
      end

      def save_member(member)
        db_member = DB::Member.last(username: member.username)
        db_member = DB::Member.new if not db_member

        core_to_db member, db_member
        db_member.save

        member.loans.each { |loan| save_loan loan, db_member.id }
      end

      def save_loan(loan, member_id)
        db_loan = DB::Loan.last(library_book_id: loan.library_book_id, member_id: member_id)
        db_loan = DB::Loan.new if not db_loan

        core_to_db loan, db_loan
        db_loan.book   = DB::Book.last(library_id: loan.library_book_id)
        db_loan.member = DB::Member.get(member_id)
        db_loan.save
      end

      def save_administrator(administrator)
        db_administrator = DB::Administrator.last(username: administrator.username)
        db_administrator = DB::Administrator.new if not db_administrator

        core_to_db administrator, db_administrator
        db_administrator.save
      end

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

      def delete_book(library_id)
        DB::Book.last(library_id: library_id).destroy
      end

      def delete_member(username)
        DB::Member.last(username: username).destroy
      end

      def delete_administrator(username)
        DB::Administrator.last(username: username).destroy
      end
    end
  end
end