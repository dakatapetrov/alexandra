class AlexandraMain < Sinatra::Base
  get '/loan/:id' do
    @loan    = Alexandra::DB::Loan.get params[:id].to_i
    username = Alexandra::DB::Member.get(@loan.member_id).username

    user_specific username

    if @loan then erb :loan
    else not_found
    end
  end

  post '/loan/:id/return' do
    protected!

    loan               = Alexandra::DB::Loan.get params[:id].to_i
    loan.returned      = true
    loan.date_returned = Date.today
    loan.save

    book      = Alexandra::DB::Book.last library_id: loan.library_book_id
    book.free = true
    book.save

    redirect "/loan/#{params[:id]}"
  end

  get '/:loan/:id/return' do
    protected!

    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_return
    else not_found
    end
  end

  post '/loan/:id/extend' do
    protected!

    loan         =  Alexandra::DB::Loan.get params[:id].to_i
    loan.to_date += params[:extend_by].to_i
    loan.save

    redirect "/loan/#{params[:id]}"
  end

  get '/:loan/:id/extend' do
    protected!

    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_extend
    else not_found
    end
  end

  post '/loan/:id/delete' do
    protected!

    Alexandra::DB::Loan.get(params[:id].to_i).destroy

    redirect "/"
  end

  get '/:loan/:id/delete' do
    protected!

    @loan = Alexandra::DB::Loan.get params[:id].to_i

    if @loan then erb :loan_delete
    else not_found
    end
  end
end