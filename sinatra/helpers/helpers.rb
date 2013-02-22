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

    def escape(text)
      CGI.escapeHTML(text)
    end
  end
end