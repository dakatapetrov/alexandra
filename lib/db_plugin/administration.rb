require 'data_mapper'
require_relative '../core/administration'

DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")

module Alexandra
  module DB
    class Administrator < Alexandra::Core::Administrator
      include DataMapper::Resource
      property :id, Serial
      property :email, String, :required => true
      property :password, BCryptHash, :required => true
    
      def self.create(id, username, password)
        administrator = Administrator.new
    
        administrator.id, administrator.username = id, username
        administrator.password = password
    
        administrator
      end
    end
    
    class Administrators < Alexandra::Core::Administrators
      def initialize(administrators = Administrator.all)
        @administrators = administrators
      end
    
      def remove(id)
        Administrator.get(id).destroy
      end
    end
    
    class Library < Alexandra::Core::Library
      include DataMapper::Resource
      property :id, Serial, :default => 1
      property :name, String, :required => true
      #property :fine
    
      def self.create(name, fine)
        library = Library.new
    
        library.name = name
        library.fine = fine
    
    
        library
      end
    end
  end
end
