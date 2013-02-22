class AlexandraMain < Sinatra::Base
  get '/book' do
    redirect '/book/search'
  end

  post '/book/add' do
    keys          = [:library_id, :title, :author, :loan_period]
    to_update     = [:title, :author, :series, :publisher, :genre, :language]
    to_update_int = [:library_id, :loan_period, :isbn, :series_id, :year_published, :page_count]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :add_book, locals: { failure: "Fields marked with * are required!"}
    elsif Alexandra::DB::Book.last library_id: params[:library_id]
      erb :add_book, locals: { failure: "A book with the same library id found!"}
    else
      book = Alexandra::DB::Book.new

      update_attributes     book, to_update
      update_attributes_int book, to_update_int

      book.save

      erb :add_book, locals: { success: "Book added successfully!" }
    end
  end

  get '/book/add' do
    protected!
    erb :add_book
  end

  post '/book/:library_id/delete' do
    Alexandra::DB::Book.last(library_id: params[:library_id]).destroy
    redirect '/'
  end

  get '/book/:library_id/delete' do
    protected!

    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    if @book then erb :book_delete
    else not_found
    end
  end

  post '/book/:library_id/loan' do
    member = Alexandra::DB::Member.last username:   params[:username]
    @book  = Alexandra::DB::Book.last   library_id: params[:library_id].to_i

    if not @book.free
      erb :book_loan, locals: { failure: "Book already loaned!" }
    elsif not member
      erb :book_loan, locals: { failure: "Bad username!" }
    else
      loan                 = Alexandra::DB::Loan.new
      loan.member          = member
      loan.book            = @book
      loan.to_date         = Date.today + @book.loan_period
      loan.library_book_id = @book.library_id
      loan.save

      @book.free = false
      @book.save

      erb :book_loan, locals: { success: "Book loaned successfully!" }
    end
  end

  get '/book/:library_id/loan' do
    protected!

    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    if @book then erb :book_loan
    else not_found
    end
  end

  post '/book/:library_id/edit' do
    keys          = [:title, :author, :loan_period]
    to_update     = [:title, :author, :series, :publisher, :genre, :language]
    to_update_int = [:loan_period, :isbn, :series_id, :year_published, :page_count]

    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :book_edit, locals: { failure: "Fields marked with * are required!"}
    else
      update_attributes     @book, to_update
      update_attributes_int @book, to_update_int

      @book.save

      erb :book_edit, locals: { success: "Book updated successfully" }
    end
  end

  get '/book/:library_id/edit' do
    protected!

    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    erb :book_edit
  end

  post '/book/search' do
    redirect "/book/search?criteria=#{params[:content].gsub(/\s/, "+")}&"\
             "by=#{params[:by]}&method=#{params[:method]}"
  end

  get '/book/search' do
    private!
    if params[:criteria] and params[:by] and params[:method]
      @catalog = Alexandra::Core::Catalog.new Alexandra::DB::Book.all

      @search = params[:criteria].split("+")

      criteria = Alexandra::Core::Criteria.method(params[:by].to_sym).call ""

      if params[:method] = "and"
        @search.each do |string|
          criteria = criteria & Alexandra::Core::Criteria.method(params[:by].to_sym).call(string)
        end
      elsif params[:method] = "or"
        @search.each do |string|
          criteria = criteria | Alexandra::Core::Criteria.method(params[:by].to_sym).call(string)
        end
      end

      @catalog = @catalog.filter criteria
    end

    erb :search_book
  end

  get '/book/list' do
    private!
    @books = Alexandra::DB::Book.all

    erb :book_list
  end

  get '/book/:library_id' do
    private!
    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    erb :book
  end
end