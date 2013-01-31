require 'rspec'
require './lib/circulation'

describe "Extension" do
  let (:extension) { Extension.new(Date.today, Date.today + 3) }

  it "can get info for extension" do
    extension.from_date.should eq Date.today
    extension.to_date.should eq Date.today + 3
  end
end

describe "Loans" do
  let(:game_of_thrones) do
    Book.new 2, "978-954-585-293-8", "A Game of Thrones",
      "A Song of Fire and Ice", 1, "George R.R. Martin",
      2001, "Bard", 702,
      ["Fantasy", "Novels"], "Bulgarian", 31
  end

  let(:loan) { Loan.new game_of_thrones }

  it "can get info from loan" do
    loan.from_date.should eq Date.today
    loan.to_date.should eq (Date.today + 31)
    loan.book_id.should eq 2
    loan.returned?.should eq false
  end

  it "can extend loan period by given amound of days" do
    loan.extend_by 3

    loan.to_date.should eq (Date.today + 34)
  end

  it "can extend loan period to given date" do
    loan.extend_to Date.new(2012, 3, 4)

    loan.to_date.should eq Date.new(2012, 3, 4)
  end

  it "can list all extensions" do
    loan.extend_by 3
    loan.extend_to Date.new(2012, 3, 20)

    extensions= loan.extensions

    extensions[0].from_date.should eq Date.today
    extensions[0].to_date.should eq Date.today + 34
    extensions[1].from_date.should eq Date.today
    extensions[1].to_date.should eq Date.new(2012, 3, 20)
  end

  it "can return a book" do
    loan.return.should eq 0
    loan.returned?.should eq true
  end
end

describe "Member" do
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

  let (:member) { Member.new "testuser", "testuser@testhost.com", "123456" }

  def compare_loans(loan, book_id, from_date, to_date)
    loan.book_id.should eq book_id
    loan.from_date.should eq from_date
    loan.to_date.should eq to_date
  end

  it "can get member info" do
    member.username.should eq "testuser"
    member.email.should eq "testuser@testhost.com"
    member.email_confirmed?.should eq false
  end

  it "can onfirm e-mail" do
    member.confirm_email

    member.email_confirmed?.should eq true
  end

  it "can check user password" do
    member.password?("123456").should eq true
    member.password?("randompwd").should eq false
  end

  it "can change user password" do
    member.change_password "password"

    member.password?("123456").should eq false
    member.password?("password").should eq true
  end

  it "can change user e-mail address" do
    member.change_email "someone@example.com"

    member.email.should eq "someone@example.com"
    member.email_confirmed?.should eq false
  end

  it "can get loans list" do
    member.take game_of_thrones
    member.take storm_of_swords

    compare_loans member.loans[0], 2, Date.today, Date.today + 31
    compare_loans member.loans[1], 3, Date.today, Date.today + 31
  end

  it "can get returned loans" do
    member.take game_of_thrones
    member.take storm_of_swords

    member.return_book game_of_thrones

    compare_loans member.returned_loans.first, 2, Date.today, Date.today + 31
  end

  it "can get unreturned loans" do
    member.take game_of_thrones
    member.take storm_of_swords

    member.return_book game_of_thrones

    compare_loans member.unreturned_loans.first, 3, Date.today, Date.today + 31
  end
end
