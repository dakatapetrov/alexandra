class AlexandraMain < Sinatra::Base
  not_found do
    erb :not_found
  end
end