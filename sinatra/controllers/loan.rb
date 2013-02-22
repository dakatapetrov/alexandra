class AlexandraMain < Sinatra::Base
  get '/loan/:id' do
    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan
    else not_found
    end
  end

  post '/loan/:id/return' do
    loan               = Alexandra::DB::Loan.get params[:id].to_i
    loan.returned      = true
    loan.date_returned = Date.today
    loan.save

    redirect "/loan/#{params[:id]}"
  end

  get '/:loan/:id/return' do
    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_return
    else not_found
    end
  end

  post '/loan/:id/extend' do
    loan         =  Alexandra::DB::Loan.get params[:id].to_i
    loan.to_date += params[:extend_by].to_i
    loan.save

    redirect "/loan/#{params[:id]}"
  end

  get '/:loan/:id/extend' do
    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_extend
    else not_found
    end
  end

  post '/loan/:id/delete' do
    Alexandra::DB::Loan.get(params[:id].to_i).destroy

    redirect "/"
  end

  get '/:loan/:id/delete' do
    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_delete
    else not_found
    end
  end
end