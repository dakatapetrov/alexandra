class AlexandraMain < Sinatra::Base
  get '/book' do
    redirect '/book/search'
  end

  post '/book/add' do
    keys = [:library_id, :title, :author, :loan_period]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :add_book, locals: { failure: "Fields marked with * are required!"}
    elsif Alexandra::DB::Book.last library_id: params[:library_id]
      erb :add_book, locals: { failure: "A book with the same library id found!"}
    else
      book = Alexandra::DB::Book.new
      book.library_id     = params[:library_id].to_i  if params[:library_id]
      book.title          = params[:title]            if params[:title]
      book.author         = params[:author]           if params[:author]
      book.loan_period    = params[:loan_period].to_i if params[:loan_period]
      book.isbn           = params[:isbn].to_i        if params[:isbn]
      book.series         = params[:series]           if params[:series]
      book.series_id      = params[:series_id]        if params[:series_id]
      book.year_published = params[:year_published]   if params[:year_published]
      book.publisher      = params[:publisher]        if params[:publisher]
      book.page_count     = params[:page_count].to_i  if params[:page_count]
      book.genre          = params[:genre]            if params[:genre]
      book.language       = params[:language]         if params[:language]
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

  post '/book/:library_id/edit' do
    keys = [:title, :author, :loan_period]
    @book = Alexandra::DB::Book.last library_id: params[:library_id]

    if keys.any? { |key| params[key].to_s.empty? }
      erb :book_edit, locals: { failure: "Fields marked with * are required!"}
    else
      @book.library_id     = params[:library_id].to_i  if params[:library_id]
      @book.title          = params[:title]            if params[:title]
      @book.author         = params[:author]           if params[:author]
      @book.loan_period    = params[:loan_period].to_i if params[:loan_period]
      @book.isbn           = params[:isbn].to_i        if params[:isbn]
      @book.series         = params[:series]           if params[:series]
      @book.series_id      = params[:series_id]        if params[:series_id]
      @book.year_published = params[:year_published]   if params[:year_published]
      @book.publisher      = params[:publisher]        if params[:publisher]
      @book.page_count     = params[:page_count].to_i  if params[:page_count]
      @book.genre          = params[:genre]            if params[:genre]
      @book.language       = params[:language]         if params[:language]
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
    redirect "/book/search?criteria=#{params[:content].gsub(/\s/, "+")}&by=#{params[:by]}"
  end

  get '/book/search' do
    private!
    if params[:criteria] and params[:by]
      @catalog = Alexandra::Core::Catalog.new Alexandra::DB::Book.all

      @search = params[:criteria].split("+")

      criteria = Alexandra::Core::Criteria.method(params[:by].to_sym).call ""

      @search.each do |string|
        criteria = criteria & Alexandra::Core::Criteria.method(params[:by].to_sym).call(string)
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