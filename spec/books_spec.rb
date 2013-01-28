require 'rspec'
require './lib/book'

describe "Book" do
  let(:clash_of_kings) do
    Book.new 1, "978-954-585-299-2", "A Clash of Kings",
      "A Song of Fire and Ice", 2, "George R.R. Martin",
      2001, "Bard", 729,
      ["Fantasy", "Novels"], "Bulgarian", 31
    end

  it "can return basic info" do
    clash_of_kings.id.should eq 1
    clash_of_kings.isbn.should eq "978-954-585-299-2"
    clash_of_kings.title.should eq "A Clash of Kings"
    clash_of_kings.series.should eq "A Song of Fire and Ice"
    clash_of_kings.series_id.should eq 2
    clash_of_kings.author.should eq "George R.R. Martin"
    clash_of_kings.year_published.should eq 2001
    clash_of_kings.publisher.should eq "Bard"
    clash_of_kings.page_count.should eq 729
    clash_of_kings.genres.should eq ["Fantasy", "Novels"]
    clash_of_kings.language.should eq "Bulgarian"
    clash_of_kings.can_take_home?.should eq true
    clash_of_kings.free?.should eq true
    clash_of_kings.rent_period.should eq 31
  end

  it "can update info" do
    clash_of_kings.id =  2
    clash_of_kings.isbn = "978-0-5533-81696"
    clash_of_kings.title = "A Clash of Kingss"
    clash_of_kings.series = "A Song of Fire and Icee"
    clash_of_kings.series_id = 3
    clash_of_kings.author = "George R.R. Martinn"
    clash_of_kings.year_published = 2002
    clash_of_kings.publisher = "Bardd"
    clash_of_kings.page_count = 728
    clash_of_kings.genres = ["Fantasy", "Novels", "Epic"]
    clash_of_kings.language = "English"
    clash_of_kings.rent_period = 32

    clash_of_kings.id.should eq 2
    clash_of_kings.isbn.should eq "978-0-5533-81696"
    clash_of_kings.title.should eq "A Clash of Kingss"
    clash_of_kings.series.should eq "A Song of Fire and Icee"
    clash_of_kings.series_id.should eq 3
    clash_of_kings.author.should eq "George R.R. Martinn"
    clash_of_kings.year_published.should eq 2002
    clash_of_kings.publisher.should eq "Bardd"
    clash_of_kings.page_count.should eq 728
    clash_of_kings.genres.should eq ["Fantasy", "Novels", "Epic"]
    clash_of_kings.language.should eq "English"
    clash_of_kings.can_take_home?.should eq true
    clash_of_kings.free?.should eq true
    clash_of_kings.rent_period.should eq 32
  end

  it "can raise error on wrong ISBN" do
    expect{ clash_of_kings.isbn = "978-954-585-299-3" }.to raise_error(Book::InvalidISBN)
  end

  it "can have a nil value for isbn" do
    clash_of_kings.isbn = nil

    clash_of_kings.isbn.should eq nil
  end

  it "can change boolean variables" do
    clash_of_kings.take
    clash_of_kings.free?.should eq false

    clash_of_kings.return
    clash_of_kings.free?.should eq true

    clash_of_kings.disable_taking_home
    clash_of_kings.can_take_home?.should eq false

    clash_of_kings.enable_taking_home
    clash_of_kings.can_take_home?.should eq true
  end
end
