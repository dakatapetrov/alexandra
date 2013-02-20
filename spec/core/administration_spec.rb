require 'spec_helper'
require 'core/administration'

module Alexandra::Core
  describe "Core::Administrator" do
    let(:admin) { Administrator.new "admin", "123456" }

    it "can get administrator info" do
      admin.username.should eq "admin"
    end

    it "converts username to downcase" do
      Administrator.new("AdMiN", "123456").username.should eq "admin"
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
    let :admins do
      Administrators.new [
        Administrator.new("admin", "123456"),
        Administrator.new("rootoor", "asdasd"),
        Administrator.new("killbill", "killbill"),
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
      admins.add Administrator.new "superuser", "passwd"

      admins.map(&:username).should =~ [
        "admin",
        "rootoor",
        "killbill",
        "superuser",
      ]
    end

    it "has unique usernames" do
      expect{ admins.add Administrator.new "admin", "123456" }.
        to raise_error(Administrators::UsernameTaken)
    end

    it "can remove administrator" do
      admins.remove "rootoor"

      admins.map(&:username).should =~ [
        "admin",
        "killbill",
      ]
    end
  end

  describe "Core::Library" do
    let(:lib) { Library.new "SU Library", 0.25 }

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
