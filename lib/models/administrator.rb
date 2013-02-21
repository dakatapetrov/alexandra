require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'bcrypt'

module Alexandra
  module DB

    DataMapper::setup(:default, DATABASE_PATH)

    class Administrator
      include DataMapper::Resource

      property :id,       Serial
      property :username, String,     required: true, unique: true
      property :password, BCryptHash, required: true
    end

    DataMapper.finalize.auto_upgrade!
  end
end
