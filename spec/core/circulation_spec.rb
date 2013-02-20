require 'spec_helper'
require 'core/circulation'

module Alexandra::Core
  describe "Core::Loan" do
    let(:loan) { Loan.new 2, 31 }

    it "can get info from loan" do
      loan.from_date.should     eq Date.today
      loan.to_date.should       eq Date.today + 31
      loan.book_id.should       eq 2
      loan.returned?.should     eq false
      loan.date_returned.should eq nil
    end

    it "can extend loan period by given amound of days" do
      loan.extend_by 3

      loan.to_date.should eq Date.today + 34
    end

    it "can extend loan period to given date" do
      loan.extend_to Date.new(2012, 3, 4)

      loan.to_date.should eq Date.new(2012, 3, 4)
    end

    it "can return a book" do
      loan.return.should        eq 0
      loan.returned?.should     eq true
      loan.date_returned.should eq Date.today
    end
  end

  describe "Core::Member" do

    let(:member) { Member.new "testuser", "testuser@testhost.com", "123456" }

    def compare_loans(loan, book_id, from_date, to_date)
      loan.book_id.should   eq book_id
      loan.from_date.should eq from_date
      loan.to_date.should   eq to_date
    end

    it "can get member info" do
      member.username.should         eq "testuser"
      member.email.should            eq "testuser@testhost.com"
      member.email_confirmed?.should eq false
      member.date_registred.should   eq Date.today
    end

    it "conerts username to downcase" do
      Member.new("MemBEr", "member@somewhere.name", "123456").username.should eq "member"
    end

    it "can confirm e-mail" do
      member.confirm_email

      member.email_confirmed?.should eq true
    end

    it "can check user password" do
      member.password?("123456").should    eq true
      member.password?("randompwd").should eq false
    end

    it "can change user password" do
      member.password = "password"

      member.password?("123456").should   eq false
      member.password?("password").should eq true
    end

    it "can change user e-mail address" do
      member.email = "someone@example.com"

      member.email.should            eq "someone@example.com"
      member.email_confirmed?.should eq false
    end

    it "can get loans list" do
      member.take 2, 31
      member.take 3, 31

      compare_loans member.loans[0], 2, Date.today, Date.today + 31
      compare_loans member.loans[1], 3, Date.today, Date.today + 31
    end

    it "can get returned loans" do
      member.take 2, 31
      member.take 3, 31

      member.return 2 

      compare_loans member.returned_loans.first, 2, Date.today, Date.today + 31
    end

    it "can get unreturned loans" do
      member.take 2, 31 
      member.take 3, 31

      member.return 2

      compare_loans member.unreturned_loans.first, 3, Date.today, Date.today + 31
    end
  end

  describe "Core::Members" do
    let :members do
      Members.new [
        Member.new("member",  "member@member.com",     "123456"),
        Member.new("someone", "someone@example.com",   "321123"),
        Member.new("noone",   "unknown@somewhere.ddz", "asdasd"),
      ]
    end

    it "can list all usernames" do
      members.usernames.should =~ [
        "member",
        "someone",
        "noone",
      ]
    end

    it "can list all emails" do
      members.emails.should =~ [
        "member@member.com",
        "someone@example.com",
        "unknown@somewhere.ddz",
      ]
    end

    it "is enumerable" do
      members.map(&:username).should =~ [
        "member",
        "someone",
        "noone",
      ]
    end

    it "can add member" do
      members.add Member.new"rootoor", "root@admin.com", "passwd"

      members.usernames.should =~ [
        "member",
        "someone",
        "noone",
        "rootoor",
      ]
    end

    it "has unique usernames" do
      expect{ members.add Member.new "member", "somewhere@nvm.com", "passwd" }.
        to raise_error(Members::UsernameTaken)
    end

    it "has unique e-mail addresses" do
      expect{ members.add Member.new "unkniwn", "member@member.com", "passwd" }.
        to raise_error(Members::EmailTaken)
    end

    it "can remove member" do
      members.remove "noone"

      members.usernames.should =~ [
        "member",
        "someone",
      ]
    end
  end
end
