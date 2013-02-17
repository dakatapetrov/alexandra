require 'spec_helper'
require 'db_plugin/administration'

module Alexandra::DB
  describe "DB::Administrator" do
    let(:admin) { Administrator.create 1, "admin", "123456" }
  
    it "can get administrator info" do
      admin.id.should eq 1
      admin.username.should eq "admin"
    end
  
    it "can check password" do
      admin.password?("123456").should eq true
      admin.password?("random").should eq false
    end
  
    it "can change password" do
      admin.password = "asdasd"
  
      admin.password?("asdasd").should eq true
      admin.password?("123456").should eq false
    end
  end
  
  describe "Core::Administrators" do
    let(:admins) do
      Administrators.new [
        Administrator.create(1, "admin", "123456"),
        Administrator.create(2, "rootoor", "asdasd"),
        Administrator.create(3, "killbill", "killbill"),
      ]
    end
  
    it "can list usernames" do
      admins.usernames.should =~ [
        "admin",
        "rootoor",
        "killbill",
      ]
    end
  
    it "is enumerable" do
      admins.map(&:username).should =~ [
        "admin",
        "rootoor",
        "killbill",
      ]
    end
  
    it "can add administrator" do
      admins.add Administrator.create 4, "superuser", "passwd"
  
      admins.map(&:username).should =~ [
        "admin",
        "rootoor",
        "killbill",
        "superuser",
      ]
    end
  
    #it "can remove administrator" do
    #  admins.remove 2
  
    #  admins.map(&:username).should =~ [
    #    "admin",
    #    "killbill",
    #  ]
    #end
  end
  
  describe "Core::Library" do
    let(:lib) { Library.create "SU Library", 0.25 }
  
    it "can get library info" do
      lib.name.should eq "SU Library"
      lib.fine.should eq 0.25
    end
  
    it "can change name and fine" do
      lib.name = "TU Library"
      lib.fine = 0.2
  
      lib.name.should eq "TU Library"
      lib.fine.should eq 0.2
    end
  end
end
