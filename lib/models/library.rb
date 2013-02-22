module Alexandra
  module DB
    class Library
      include DataMapper::Resource

      property :id,   Serial
      property :name, String, required: true
      property :fine, Float,  required: true
    end
  end
end