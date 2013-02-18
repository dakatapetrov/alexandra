require 'bcrypt'

module Alexandra
  module Core
    class Administrator
      attr_accessor :id, :username

      def initialize(id, username, password)
        @id       = id
        @username = username.downcase
        @password = BCrypt::Password.create password
      end

      def password?(password)
        @password == password
      end

      def password=(password)
        @password = BCrypt::Password.create password
      end
    end

    class Administrators
      include Enumerable

      def initialize(administrators = [])
        @administrators = administrators
      end

      def each(&block)
        @administrators.each(&block)
      end

      def usernames
        @administrators.map(&:username)
      end

      class UsernameTaken < RuntimeError
      end

      def add(administrator)
        raise UsernameTaken if @administrators.any? { |a| a.username == administrator.username }

        @administrators << administrator
      end

      def remove(id)
        @administrators.delete_if { |admin| admin.id == id }
      end
    end

    class Library
      attr_accessor :name, :fine

      def initialize(name, fine)
        @name = name
        @fine = fine
      end
    end
  end
end