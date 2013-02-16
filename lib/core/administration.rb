require 'bcrypt'

module Alexandra
  module Core
    class Administrator
      attr_reader :id, :username
    
      def initialize(id, username, password)
        @id, @username = id, username
        @password = BCrypt::Password.create(password)
      end
    
      def password?(password)
        @password == password
      end
    
      def password=(password)
        @password = BCrypt::Password.create(password)
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
    
      def add(administrator)
        @administrators << administrator
      end
    
      def remove(id)
        @administrators.delete_if { |admin| admin.id == id }
      end
    end
    
    class Library
      attr_accessor :name, :fine
    
      def initialize(name)
        @name = name
      end
    end
  end
end
