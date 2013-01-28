require 'rspec'
require './lib/catalog.rb'

describe "Catalog" do
  let(:clash_of_kings) do
    Book.new 1, "978-954-585-299-2", "A Clash of Kings",
      "A Song of Fire and Ice", 2, "George R.R. Martin",
      2001, "Bard", 729,
      ["Fantasy", "Novels"], "Bulgarian", 31
  end

  let(:game_of_thrones) do
    Book.new 2, "978-954-585-293-8", "A Game of Thrones",
      "A Song of Fire and Ice", 1, "George R.R. Martin",
      2001, "Bard", 702,
      ["Fantasy", "Novels"], "Bulgarian", 31
  end

  let(:storm_of_swords) do
    Book.new 3, "978-954-585-310-4", "A Storm of Swords",
      "A Song of Fire and Ice", 3, "George R.R. Martin",
      2001, "Bard", 928,
      ["Fantasy", "Novels"], "Bulgarian", 31
  end

  let(:java2) do
    Book.new 4, "978-954-685-172-5", "Java 2",
      nil, nil, "Herbert Schildt",
      2009, "Softpres", 584,
      ["IT"], "Bulgarian", 40
  end

  let(:pragmatic_programmer) do
    Book.new 5, "978-0-2016-16228", "The Pragmatic Programmer: From Journeyman to Master",
      nil, nil, "Andrew Hunt, David Thomas",
    1999, "Addison-Wesley Professional", 352,
    ["IT"], "English", 20
  end

  let(:witching_hour) do
    Book.new 6, "978-0-3453-84469", "The Witching Hour",
      "Lives of the Mayfair Witches", 1, "Anne Rice",
      1993, "Ballantine Books", 1038,
      ["Horror", "Fantasy", "Gothic"], "English", 46
  end

  let(:pod_igoto) do
    Book.new 7, nil, "Pod Igoto",
      nil, nil, "Ivan Vazov",
      1990, "Prosveta", 412,
      ["Novels"], "Bulgarian", 31
  end

  let(:catalog) do
    Catalog.new [
      clash_of_kings,
      game_of_thrones,
      storm_of_swords,
      pragmatic_programmer,
      java2,
      witching_hour,
      pod_igoto
    ]
  end

  it "can find all book titles in catalog" do
    catalog.titles.should =~ [
      "A Clash of Kings",
      "A Game of Thrones",
      "A Storm of Swords",
      "Java 2",
      "The Pragmatic Programmer: From Journeyman to Master",
      "The Witching Hour",
      "Pod Igoto"
    ]
  end 

  it "can find all ISBNs in catalog" do
    catalog.isbns.should =~ [
      "978-954-585-299-2",
      "978-954-585-293-8",
      "978-954-585-310-4",
      "978-954-685-172-5",
      "978-0-2016-16228",
      "978-0-3453-84469"
    ]
  end

  it "can find all series in catalog" do
    catalog.series.should =~ [
      "A Song of Fire and Ice",
      "Lives of the Mayfair Witches"
    ]
  end

  it "can find all authors in catalog" do
    catalog.authors.should =~ [
      "George R.R. Martin",
      "Andrew Hunt, David Thomas",
      "Herbert Schildt",
      "Anne Rice",
      "Ivan Vazov"
     ]
  end

  it "can find all publishers in catalog" do
    catalog.publishers.should =~ [
      "Bard",
      "Softpres",
      "Ballantine Books",
      "Addison-Wesley Professional",
      "Prosveta"
    ]
  end

  it "can list all genres in catalog" do
    catalog.genres.should =~ [
      "Fantasy",
      "Novels",
      "IT",
      "Gothic",
      "Horror"
    ]
  end

  it "can be filtered by title" do
    filtered = catalog.filter Criteria.title("Pod Igoto")
    filtered.map(&:author).should =~ ["Ivan Vazov"]
  end

  it "can be filtered by series" do
    filtered = catalog.filter Criteria.series("A Song of Fire and Ice")
    filtered.map(&:title).should =~ ["A Clash of Kings", "A Storm of Swords", "A Game of Thrones"]
  end

  it "can eb filtered by author" do
    filtered = catalog.filter Criteria.author("George R.R. Martin")
    filtered.map(&:title).should =~ ["A Clash of Kings", "A Storm of Swords", "A Game of Thrones"]
  end

  it "can be filtered by ISBN" do
    filtered = catalog.filter Criteria.isbn("978-954-585-299-2")
    filtered.map(&:title).should =~ ["A Clash of Kings"]
  end

  it "supports complex filtering" do
    filtered = catalog.filter Criteria.author("Ivan Vazov") | Criteria.author("Anne Rice")
    filtered.map(&:title).should =~ ["Pod Igoto", "The Witching Hour"]

    filtered = catalog.filter Criteria.author("George R.R. Martin") & Criteria.title("A Clash of Kings")
    filtered.map(&:title).should =~ ["A Clash of Kings"]
  end

  it "can add book to colection" do
    catalog.add Book.new 8, "978-0-4512-05768", "The Godfather",
      "Mario Puzo's Mafia", nil, "Mario Puzo",
      2002, "NAL Trade", 448,
      ["Classics", "Novels"], "English", 30

    catalog.isbns.should =~ [
      "978-954-585-299-2",
      "978-954-585-293-8",
      "978-954-585-310-4",
      "978-954-685-172-5",
      "978-0-2016-16228",
      "978-0-3453-84469",
      "978-0-4512-05768"
    ]
  end

  it "throws exception on attempt to add book with id already in the catalog" do
    expect do
      catalog.add Book.new 6, nil, "A book",
        nil, nil, "Me",
        2013, "Publisher", 0,
        nil, "Bulgarian", 1
    end.to raise_error(Catalog::BookIDExists)
  end

  it "can edit book in catalog" do
    catalog.edit(7).genres = ["Novels", "Bulgarian"]

    catalog.genres.should =~ [
      "Fantasy",
      "Novels",
      "IT",
      "Gothic",
      "Horror",
      "Bulgarian"
    ]
  end

  it "can delete book from catalog" do
    catalog.delete 7

    catalog.authors.should =~ [
      "George R.R. Martin",
      "Andrew Hunt, David Thomas",
      "Herbert Schildt",
      "Anne Rice"
     ]
  end
end
