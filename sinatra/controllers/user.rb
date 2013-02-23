class AlexandraMain < Sinatra::Base
  post '/login' do
    user = Alexandra::DB::Member.last username: params[:username] if params[:username]
    if user and user.password == params[:password]
      session[:username] = params[:username]
      session[:level]    = "user"

      redirect '/book/search'
    else
      erb :user_login, locals: { failure: "Username and/or password incorect!" }
    end
  end

  get '/login' do
    if session[:username] then redirect '/book/search'
    else erb :user_login
    end
  end

  post '/register' do
    keys = [:username, :email, :password]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :user_register, locals: { failure: "All fields required!" }
    elsif not valid_username? params[:username]
      erb :user_register, locals: { failure: "Ivalid username!" }
    elsif Alexandra::DB::Member.last username: params[:username]
      erb :user_register, locals: { failure: "Username taken!" }
    elsif not valid_password? params[:password]
      erb :user_register, locals: { failure: "Password too short!"}
    elsif params[:password] != params[:confirm_password]
      erb :user_register, locals: { failure: "Password did not match!" }
    elsif params[:email] != params[:confirm_email]
      erb :user_register, locals: { failure: "Email did not match!" }
    elsif not valid_email? params[:email]
      erb :user_register, locals: { failure: "Ivalid e-mail!" }
    elsif Alexandra::DB::Member.last email: params[:email]
      erb :user_register, locals: { failure: "Email taken!" }
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

  get '/user/list' do
    protected!

    @users = Alexandra::DB::Member.all

    if @users then erb :user_list
    else not_found
    end
  end

  get '/user/:username' do
    user_specific params[:username]

    @user = Alexandra::DB::Member.last username: params[:username]

    if not @user then not_found
    else erb :user
    end
  end

  post '/user/:username/edit' do
    user_specific params[:username]

    keys      = [:email, :old_password]
    to_update = [:email, :password]
    @user     = Alexandra::DB::Member.last username: params[:username]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :user_edit, locals: { failure: "All fields required!" }
    elsif @user.password != params[:old_password]
      erb :user_edit, locals: { failure: "Wrong password!" }
    elsif params[:password] != params[:confirm_password]
      erb :user_edit, locals: { failure: "Passwords did not match!" }
    elsif not valid_password? params[:password]
      erb :user_edit, locals: { failure: "Password too short!"}
    elsif params[:email] != params[:confirm_email]
      erb :user_edit, locals: { failure: "Email did not match!" }
    elsif not valid_email? params[:email]
      erb :user_edit, locals: { failure: "Ivalid e-mail!" }
    elsif params[:email] != @user.email and Alexandra::DB::Member.last email: params[:email]
      erb :user_edit, locals: { failure: "Email taken!" }
    else
      update_attributes @user, to_update
      @user.save

      erb :user_edit, locals: { success: "User updated successfully" }
    end
  end

  get '/user/:username/edit' do
    user_specific params[:username]

    @user = Alexandra::DB::Member.last username: params[:username]

    if not @user then not_found
    else erb :user_edit
    end
  end

  post '/user/:username/delete' do
    protected!

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

  get '/user/:username/loans' do
    user_specific params[:username]

    @user = Alexandra::DB::Member.last username: params[:username]

    if @user
      @returned   = @user.loans.all(returned: true, order: :date_returned.desc)
      @unreturned = @user.loans.all(returned: false, order: :to_date.asc)

      erb :user_loans
    else not_found
    end
  end
end