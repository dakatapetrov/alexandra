Encoding.default_internal = Encoding.default_external = 'UTF-8' if RUBY_VERSION >= '1.9'
require 'sinatra/base'
require 'sinatra/cookies'
require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'bcrypt'

module Alexandra
  module Structure
    MODELS      = 'lib/models'
    VIEWS       = 'sinatra/views'
    CONTROLLERS = 'sinatra/controllers'
    HELPERS     = 'sinatra/helpers'
    PUBLIC      = 'sinatra/public'

    DATABASE_PATH = "sqlite3:///home/dakata/Documents/Development/Ruby/alexandra/db/development.db"
  end
end

DataMapper::Logger.new(STDOUT, :debug)

DataMapper.setup(:default, Alexandra::Structure::DATABASE_PATH)

Dir[File.join Alexandra::Structure::MODELS, '*.rb'].each do |file|
  require "./#{file}"
end

DataMapper.auto_upgrade!
DataMapper.finalize

Dir[File.join 'lib/core', '*.rb'].each do |file|
  require "./#{file}"
end

require "./lib/mapper"

class AlexandraMain < Sinatra::Base
  disable :run
  set :public_folder, Alexandra::Structure::PUBLIC
  set :views, File.join(File.dirname(__FILE__), Alexandra::Structure::VIEWS)
  set :session_secret, 'too secret'
  use Rack::Session::Cookie

  get '/' do
    redirect '/login'
  end
end

Dir[File.join Alexandra::Structure::HELPERS, '*.rb'].each do |file|
  require "./#{file}"
end

Dir[File.join Alexandra::Structure::CONTROLLERS, '*.rb'].each do |file|
  require "./#{file}"
end

AlexandraApp = Rack::Builder.app do
  map "/" do
    run AlexandraMain
  end
end

run AlexandraApp