require 'data_mapper'
require_relative '../core/administration'


module Alexandra
  module DB

    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")

    class Administrator < Alexandra::Core::Administrator
      include DataMapper::Resource
      property :id, Serial
      property :email, String, :required => true
      property :password, BCryptHash, :required => true
    end
    
    class Administrators < Alexandra::Core::Administrators
      def initialize(administrators = Administrator.all)
        @administrators = administrators
      end
    
      def remove(id)
        Administrator.get(id).destroy
      end

      def save
        @administrators.each { |administrator| administrator.save }
      end
    end
    
    class Library < Alexandra::Core::Library
      include DataMapper::Resource
      property :id, Serial, :default => 1
      property :name, String, :required => true
      property :fine, Float, :required => true

    end

    DataMapper.finalize.auto_upgrade!

  end
end
