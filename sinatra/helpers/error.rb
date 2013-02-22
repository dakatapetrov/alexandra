class AlexandraMain < Sinatra::Base
  error do
    e = request.env['sinatra.error']
    puts e.message
    e.backtrace.each{|x| puts x}
    render(:erb, "<h3>Oops, an error occurred.</h3>", :layout=>:layout)
  end
end