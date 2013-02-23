class AlexandraMain < Sinatra::Base
  post '/admin/login' do
    admin = Alexandra::DB::Administrator.last username: params[:username] if params[:username]
    if admin and admin.password == params[:password]
      session[:username]  = params[:username]
      session[:level]     = "admin"
      redirect '/book/search'
    else
      erb :admin_login, locals: { failure: "Username and/or password incorect!" }
    end
  end

  get '/admin/login' do
    redirect '/admin/first_use' if first_use?

    redirect '/book/search' if session[:username]
    erb :admin_login
  end

  post '/admin/register' do
    protected!

    keys = [:username, :password]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :admin_register, locals: { failure: "All fields required!" }
    elsif not valid_username? params[:username]
      erb :admin_register, locals: { failure: "Ivalid username!" }
    elsif Alexandra::DB::Administrator.last username: params[:username]
      erb :admin_register, locals: { failure: "Username taken!" }
    elsif not valid_password? params[:password]
      erb :admin_register, locals: { failure: "Password too short!"}
    elsif params[:password] != params[:confirm_password]
      erb :admin_register, locals: { failure: "Password did not match!" }
    else
      admin = Alexandra::DB::Administrator.new
      admin.username = params[:username]
      admin.password = params[:password]
      admin.save
      erb :admin_register, locals: { succes: "Administrator registration successfull!" }
    end
  end

  get '/admin/register' do
    redirect '/admin/first_use' if first_use?
    protected!
    erb :admin_register
  end

  post '/admin/first_use' do
    redirect '/admin/login' unless first_use?

    keys = [:username, :password]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :first_use, locals: { failure: "All fields required!" }
    elsif not valid_username? params[:username]
      erb :first_use, locals: { failure: "Ivalid username!" }
    elsif not valid_password? params[:password]
      erb :first_use, locals: { failure: "Password too short!"}
    elsif params[:password] != params[:confirm_password]
      erb :first_use, locals: { failure: "Password did not match!" }
    else
      admin = Alexandra::DB::Administrator.new
      admin.username = params[:username]
      admin.password = params[:password]
      admin.save

      redirect '/admin/login'
    end
  end

  get '/admin/first_use' do
    redirect '/admin/login' unless first_use?
    erb :first_use
  end

  get '/admin' do
    redirect '/admin/first_use' if first_use?
    redirect '/admin/login'
  end
end