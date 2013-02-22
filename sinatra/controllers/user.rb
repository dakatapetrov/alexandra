class AlexandraMain < Sinatra::Base
  post '/login' do
    user = Alexandra::DB::Member.last username: params[:username] if params[:username]
    if user and user.password == params[:password]
      session[:username] = params[:username]
      session[:level]     = "user"
      redirect '/book/search'
    else
      erb :user_login, locals: { failure: "Username and/or password incorect!" }
    end
  end

  get '/login' do
    redirect '/book/search' if session[:username]
    erb :user_login
  end

  post '/register' do
    keys = [:username, :email, :password]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :user_register, locals: { failure: "All fields required!" }
    elsif Alexandra::DB::Member.last username: params[:username]
      erb :user_register, locals: { failure: "Username taken!" }
    elsif Alexandra::DB::Member.last email: params[:email]
      erb :user_register, locals: { failure: "Email taken!" }
    elsif params[:password] != params[:confirm_password]
      erb :user_register, locals: { failure: "Password did not match!" }
    elsif params[:email] != params[:confirm_email]
      erb :user_register, locals: { failure: "Email did not match!" }
    else
      user = Alexandra::DB::Member.new
      update_attributes user, keys
      user.save
      erb :user_register, locals: { succes: "User registration successfull!" }
    end
  end

  get '/register' do
    erb :user_register
  end

  get '/logout' do
    session.clear if session[:username]
    redirect '/login'
  end

  get '/user/:username' do
    private!
    redirect '/book/search' if session[:username] != params[:username] and session[:level] != "admin"
    @user = Alexandra::DB::Member.last username: params[:username]
    if not @user then not_found
    else erb :user
    end
  end

  post '/user/:username/edit' do
    keys  = [:email, :password]
    @user = Alexandra::DB::Member.last username: params[:username]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :user_register, locals: { failure: "All fields required!" }
    elsif @user.password != params[:old_password]
      erb :user_edit, locals: { failure: "Wrong password!" }
    elsif params[:password] != params[:confirm_password]
      erb :user_edit, locals: { failure: "Passwords did not match!" }
    elsif params[:email] != params[:confirm_email]
      erb :user_register, locals: { failure: "Email did not match!" }
    else
      update_attributes @user, keys
      @user.save
      erb :user_edit, locals: { success: "User updated successfully" }
    end
  end

  get '/user/:username/edit' do
    private!
    redirect '/book/search' if session[:username] != params[:username] and session[:level] != "admin"
    @user = Alexandra::DB::Member.last username: params[:username]
    if not @user then not_found
    else erb :user_edit
    end
  end

  post '/user/:username/delete' do
    Alexandra::DB::Member.last(username: params[:username]).destroy
    redirect '/'
  end

  get '/user/:username/delete' do
    protected!

    @user = Alexandra::DB::Member.last username: params[:username]

    if @user then erb :user_delete
    else not_found
    end
  end

  get '/user/:username/history' do
    private!

    @user = Alexandra::DB::Member.last username: params[:username]

    if @user then erb :user_history
    else not_found
    end
  end
end
