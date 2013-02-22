class AlexandraMain < Sinatra::Base
  module Patterns
    TLD           = /\b[a-z]{2,3}(\.[a-z]{2})?\b/i
    HOSTNAME_PART = /\b[0-9A-Za-z]([0-9a-z\-]{,61}[0-9A-Za-z])?\b/i
    HOSTNAME      = /\b(#{HOSTNAME_PART}\.)+#{TLD}\b/i
    USERNAME      = /\b[a-z0-9][\w_\-+\.]{,200}\b/i
    EMAIL         = /\b(?<username>#{USERNAME})@(?<hostname>#{HOSTNAME})\b/i
    PASSWORD      = /\b.{6,}\b/i
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
      CGI.escapeHTML(text)
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