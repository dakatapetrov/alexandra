require 'spec_helper'
require 'core/cataloging'

module Alexandra::Core
  describe "Core::Book" do
    let :clash_of_kings do
      Book.new 1,
               "A Clash of Kings",
               "George R.R. Martin",
               31
      end

    it "can return basic info" do
      clash_of_kings.id.should             eq 1
      clash_of_kings.title.should          eq "A Clash of Kings"
      clash_of_kings.author.should         eq "George R.R. Martin"
      clash_of_kings.loanable?.should      eq true
      clash_of_kings.free?.should          eq true
      clash_of_kings.loan_period.should    eq 31
    end

    it "can update/set info" do
      clash_of_kings.id             =  2
      clash_of_kings.isbn           = "978-0-5533-81696"
      clash_of_kings.title          = "A Clash of Kingss"
      clash_of_kings.series         = "A Song of Fire and Icee"
      clash_of_kings.series_id      = 3
      clash_of_kings.author         = "George R.R. Martinn"
      clash_of_kings.year_published = 2002
      clash_of_kings.publisher      = "Bardd"
      clash_of_kings.page_count     = 728
      clash_of_kings.genre          = "Fantasy"
      clash_of_kings.language       = "English"
      clash_of_kings.loan_period    = 32

      clash_of_kings.id.should             eq 2
      clash_of_kings.isbn.should           eq "978-0-5533-81696"
      clash_of_kings.title.should          eq "A Clash of Kingss"
      clash_of_kings.series.should         eq "A Song of Fire and Icee"
      clash_of_kings.series_id.should      eq 3
      clash_of_kings.author.should         eq "George R.R. Martinn"
      clash_of_kings.year_published.should eq 2002
      clash_of_kings.publisher.should      eq "Bardd"
      clash_of_kings.page_count.should     eq 728
      clash_of_kings.genre.should          eq "Fantasy"
      clash_of_kings.language.should       eq "English"
      clash_of_kings.loanable?.should      eq true
      clash_of_kings.free?.should          eq true
      clash_of_kings.loan_period.should    eq 32
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

      clash_of_kings.loanable = false
      clash_of_kings.loanable?.should eq false

      clash_of_kings.loanable = true
      clash_of_kings.loanable?.should eq true
    end
  end

  describe "Core::Catalog" do
    let :clash_of_kings do
      Book.new 1,
               "A Clash of Kings",
               "George R.R. Martin",
               31
    end

    let :game_of_thrones do
      Book.new 2,
               "A Game of Thrones",
               "George R.R. Martin",
               31
    end

    let :storm_of_swords do
      Book.new 3,
               "A Storm of Swords",
               "George R.R. Martin",
               31
    end

    let :java2 do
      Book.new 4,
               "Java 2",
               "Herbert Schildt",
               40
    end

    let :pragmatic_programmer do
      Book.new 5,
               "The Pragmatic Programmer: From Journeyman to Master",
               "Andrew Hunt, David Thomas",
               20
    end

    let :witching_hour do
      Book.new 6,
               "The Witching Hour",
               "Anne Rice",
               46
    end

    let :pod_igoto do
      Book.new 7,
               "Pod Igoto",
               "Ivan Vazov",
               31
    end

    let :catalog do
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

    before :all do
      clash_of_kings.isbn       = "978-954-585-299-2",
      game_of_thrones.isbn      = "978-954-585-293-8",
      storm_of_swords.isbn      = "978-954-585-310-4"
      pragmatic_programmer.isbn = "978-0-2016-16228"
      java2.isbn                = "978-954-685-172-5"
      witching_hour.isbn        = "978-0-3453-84469"
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

    #it "can find all series in catalog" do
    #  catalog.series.should =~ [
    #    "A Song of Fire and Ice",
    #    "Lives of the Mayfair Witches"
    #  ]
    #end

    it "can find all authors in catalog" do
      catalog.authors.should =~ [
        "George R.R. Martin",
        "Andrew Hunt, David Thomas",
        "Herbert Schildt",
        "Anne Rice",
        "Ivan Vazov"
       ]
    end

    #it "can find all publishers in catalog" do
    #  catalog.publishers.should =~ [
    #    "Bard",
    #    "Softpres",
    #    "Ballantine Books",
    #    "Addison-Wesley Professional",
    #    "Prosveta"
    #  ]
    #end

    #it "can list all genres in catalog" do
    #  catalog.genres.should =~ [
    #    "Fantasy",
    #    "Novels",
    #    "IT",
    #    "Horror"
    #  ]
    #end

    it "can be filtered by title" do
      filtered = catalog.filter Criteria.title("Pod Igoto")

      filtered.map(&:author).should =~ ["Ivan Vazov"]
    end

    #it "can be filtered by series" do
    #  filtered = catalog.filter Criteria.series("A Song of Fire and Ice")

    #  filtered.map(&:title).should =~ ["A Clash of Kings", "A Storm of Swords", "A Game of Thrones"]
    #end

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

    it "can be filtered by substring" do
      filtered = catalog.filter Criteria.author("ivan")
      filtered.map(&:title).should =~ ["Pod Igoto"]

      filtered = catalog.filter Criteria.title("sword")
      filtered.map(&:title).should =~ ["A Storm of Swords"]

      #filtered = catalog.filter Criteria.series("fire")
      #filtered.map(&:title).should =~ ["A Clash of Kings", "A Storm of Swords", "A Game of Thrones"]

      filtered = catalog.filter Criteria.isbn("978-0-2016")
      filtered.map(&:title).should =~ ["The Pragmatic Programmer: From Journeyman to Master"]
    end

    it "can be filtered by any criteria" do
      filtered = catalog.filter Criteria.any("ivan")
      filtered.map(&:title).should =~ ["Pod Igoto"]

      filtered = catalog.filter Criteria.any("sword")
      filtered.map(&:title).should =~ ["A Storm of Swords"]

      #filtered = catalog.filter Criteria.any("fire")
      #filtered.map(&:title).should =~ ["A Clash of Kings", "A Storm of Swords", "A Game of Thrones"]

      filtered = catalog.filter Criteria.any("978-0-2016")
      filtered.map(&:title).should =~ ["The Pragmatic Programmer: From Journeyman to Master"]
    end

    it "can add book to colection" do
      catalog.add Book.new 8,
                           "The Godfather",
                           "Mario Puzo",
                           30

      catalog.get(8).isbn = "978-0-4512-05768"

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
        catalog.add Book.new 6,
                             "A book",
                             "Me",
                             1
      end.to raise_error(Catalog::BookIDExists)
    end

    it "can get book by id in catalog" do
      book = catalog.get(7)

      book.title.should eq "Pod Igoto"
    end

    it "can delete book from catalog" do
      catalog.delete 7

      catalog.authors.should =~ [
        "George R.R. Martin",
        "Andrew Hunt, David Thomas",
        "Herbert Schildt",
        "Anne Rice",
        "Mario Puzo",
       ]
    end
  end
end
