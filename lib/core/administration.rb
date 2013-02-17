require 'bcrypt'

module Alexandra
  module Core
    class Administrator
      attr_accessor :id, :username
    
      def self.create(id, username, password)
        administrator = Administrator.new

        administrator.id, administrator.username = id, username
        administrator.password = password

        administrator
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
    
      def self.create(name, fine)
        library = Library.new

        library.name = name
        library.fine = fine


        library
      end
    end
  end
end
