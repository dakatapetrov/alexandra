class AlexandraMain < Sinatra::Base
  helpers do
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