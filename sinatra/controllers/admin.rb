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
    redirect '/book/search' if session[:username]
    erb :admin_login
  end

  post '/admin/register' do
    protected!

    keys = [:username, :password]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :admin_register, locals: { failure: "All fields required!" }
    elsif params[:email] != params[:confirm_email]
      erb :admin_register, locals: { failure: "Username taken!" }
    elsif params[:password] != params[:confirm_password]
      erb :admin_register, locals: { failure: "Password did not match!" }
    else
      admin = Alexandra::DB::Member.new
      admin.username = params[:username]
      admin.email    = params[:email]
      admin.password = params[:password]
      admin.save
      erb :admin_register, locals: { succes: "Administrator registration successfull!" }
    end
  end

  get '/admin/register' do
    protected!
    erb :admin_register
  end
end