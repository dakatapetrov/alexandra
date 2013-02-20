require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'bcrypt'

module Alexandra
  module DB

    DataMapper::setup(:default, "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db")

    class Administrator
      include DataMapper::Resource

      property :id,       Serial
      property :username, String,     required: true, unique: true
      property :password, BCryptHash, required: true
    end
    
    class Library
      include DataMapper::Resource

      property :id,   Serial
      property :name, String, required: true
      property :fine, Float,  required: true
    end

    DataMapper.finalize.auto_upgrade!

  end
end
