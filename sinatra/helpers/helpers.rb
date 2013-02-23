class AlexandraMain < Sinatra::Base
  module Patterns
    TLD           = /[a-z]{2,3}(\.[a-z]{2})?/i
    HOSTNAME_PART = /[0-9A-Za-z]([0-9a-z\-]{,61}[0-9A-Za-z])?/i
    HOSTNAME      = /(#{HOSTNAME_PART}\.)+#{TLD}/i
    USERNAME      = /[a-z0-9][\w_\-+\.]{,200}/i
    EMAIL         = /(?<username>#{USERNAME})@(?<hostname>#{HOSTNAME})/i
    PASSWORD      = /.{6,}/i
    ISO_DATE      = /(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)/
  end

  helpers do
    def first_use?
      Alexandra::DB::Administrator.all.length == 0
    end

    def loggedin?
      not session[:username].nil?
    end

    def admin?
      session[:level] == "admin"
    end

    def protected!
      halt [ 401, 'Not Authorized' ] unless admin?
    end

    def private!
      redirect '/login' unless loggedin?
    end

    def user_specific!(username)
      not_found unless session[:username] == username or session[:level] == "admin"
    end

    def escape(text)
      Rack::Utils.escape_html(text)
    end

    def valid_password?(password)
      /\A#{Patterns::PASSWORD}\z/ === password
    end

    def valid_username?(username)
      /\A#{Patterns::USERNAME}\z/ === username
    end

    def valid_email?(email)
      /\A#{Patterns::EMAIL}\z/ === email
    end

    def update_attributes(object, keys)
      keys.each do |key|
        if params[key].to_s.empty?
          object.attribute_set key, nil
        else
          object.attribute_set key, params[key]
        end
      end
    end

    def update_attributes_int(object, keys)
      keys.each do |key|
        if params[key].to_s.empty?
          object.attribute_set key, nil
        else
          object.attribute_set key, params[key].to_i
        end
      end
    end
  end
end