require 'bcrypt'

module Alexandra
  module Core
    class Administrator
      attr_accessor :username

      attr_reader :password

      def initialize(username, password)
        @username = username.downcase
        @password = BCrypt::Password.create password
      end

      def password?(password)
        @password == password
      end

      def password=(password)
        if password.class == BCrypt::Password
          @password = BCrypt::Password.new password
        else
          @password = BCrypt::Password.create password
        end
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

      def remove(username)
        @administrators.delete_if { |admin| admin.username == username }
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
