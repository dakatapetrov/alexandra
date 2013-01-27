require 'rspec'
require './lib/catalog.rb'

describe "Catalog" do
  let(:clash_of_kings) { Book.new(1, "978-954-585-299-2", "A Clash of Kings", "A Song of Fire and Ice", 2, "George R.R. Martin", 2001, "Bard", 729,
    ["Fantasy", "Novels"], "Bulgarian", 31) }
  let(:game_of_thrones) { Book.new(2, "978-954-585-293-8", "A Game of Thrones", "A Song of Fire and Ice", 1, "George R.R. Martin", 2001, "Bard", 702,
    ["Fantasy", "Novels"], "Bulgarian", 31) }
  let(:storm_of_swords) { Book.new(3, "978-954-585-310-4", "A Storm of Swords", "A Song of Fire and Ice", 3, "George R.R. Martin", 2001, "Bard", 928,
    ["Fantasy", "Novels"], "Bulgarian", 31) }
  let(:java2) { Book.new(4, "978-954-685-172-5", "Java 2", nil, nil, "Herbert Schildt", 2009, "Softpres", 584, ["IT"], "Bulgarian", 40) }
  let(:pragmatic_programmer) { Book.new(5, "978-0-2016-16228", "The Pragmatic Programmer: From Journeyman to Master", nil, nil, "Andrew Hunt, David Thomas",
    1999, "Addison-Wesley Professional", 352, ["IT"], "English", 20) }
  let(:witching_hour) { Book.new(6, "978-0-3453-84469", "The Witching Hour", "Lives of the Mayfair Witches", 1, "Anne Rice", 1993, "Ballantine Books", 1038,
    ["Horror", "Fantasy", "Gothic"], "English", 46) }
  let(:pod_igoto) { Book.new(7, nil, "Pod Igoto", nil, nil, "Ivan Vazov", 1990, "Prosveta", 412, ["Novels"], "Bulgarian", 31) }

  let(:catalog) { Catalog.new }

  def insert
    catalog.add clash_of_kings
    catalog.add game_of_thrones
    catalog.add storm_of_swords
    catalog.add pragmatic_programmer
    catalog.add java2
    catalog.add witching_hour
    catalog.add pod_igoto
  end

  it "can find all book titles in catalog" do
    insert
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
    insert
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
    insert
    catalog.series.should =~ [
      "A Song of Fire and Ice",
      "Lives of the Mayfair Witches"
    ]
  end

  it "can find all authors in catalog" do
    insert
    catalog.authors.should =~ [
      "George R.R. Martin",
      "Andrew Hunt, David Thomas",
      "Herbert Schildt",
      "Anne Rice",
      "Ivan Vazov"
     ]
  end

  it "can find all publishers in catalog" do
    insert
    catalog.publishers.should =~ [
      "Bard",
      "Softpres",
      "Ballantine Books",
      "Addison-Wesley Professional",
      "Prosveta"
    ]
  end

  it "can list all genres in catalog" do
    insert
    catalog.genres.should =~ [
      "Fantasy",
      "Novels",
      "IT",
      "Gothic",
      "Horror"
    ]
  end
end
