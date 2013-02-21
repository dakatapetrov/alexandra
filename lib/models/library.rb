require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'bcrypt'

module Alexandra
  module DB
    DataMapper::setup(:default, DATABASE_PATH)

    class Library
      include DataMapper::Resource

      property :id,   Serial
      property :name, String, required: true
      property :fine, Float,  required: true
    end

    DataMapper.finalize.auto_upgrade!
  end
end