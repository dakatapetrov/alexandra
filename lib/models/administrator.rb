module Alexandra
  module DB
    class Administrator
      include DataMapper::Resource

      property :id,       Serial
      property :username, String,     required: true, unique: true
      property :password, BCryptHash, required: true
    end
  end
end
